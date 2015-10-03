#!/bin/bash
set -e
#set -o xtrace

RESET="\033[0m"
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
BOLDBLACK="\033[1m\033[30m"
BOLDRED="\033[1m\033[31m"
BOLDGREEN="\033[1m\033[32m"
BOLDYELLOW="\033[1m\033[33m"
BOLDBLUE="\033[1m\033[34m"
BOLDMAGENTA="\033[1m\033[35m"
BOLDCYAN="\033[1m\033[36m"
BOLDWHITE="\033[1m\033[37m"

# make sure all tests are passing

DEFAULT_IOS7_SIMULATOR=RxSwiftTest/iPhone-4s/iOS/7.1
DEFAULT_IOS8_SIMULATOR=RxSwiftTest/iPhone-6/iOS/8.4
DEFAULT_IOS9_SIMULATOR=RxSwiftTest/iPhone-6/iOS/9.0
DEFAULT_WATCHOS2_SIMULATOR=RxSwiftTest/AppleWatch/watchOS/2.0
DEFAULT_TVOS_SIMULATOR=RxSwiftTest/Apple-TV-1080p/tvOS/9.0

function runtime_available() {
	if [ `xcrun simctl list runtimes | grep "${1}" | wc -l` -eq 1 ]; then
		return 0
	else
		return 1
	fi
}

# used to check simulator name
function contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

function simulator_available() {
		SIMULATOR=$1
		if [ `xcrun simctl list | grep "${SIMULATOR}" | wc -l` -eq 0 ]; then
			return -1
		elif [ `xcrun simctl list | grep "${SIMULATOR}" | wc -l` -gt 1 ]; then
			echo "Multiple simulators ${SIMULATOR} found"
			xcrun simctl list | \
			grep "${SIMULATOR}" | \
			cut -d "(" -f 2 | \
			cut -d ")" -f 1 | \
			xargs xcrun simctl delete;
			exit -1
			return -1
		elif [ `xcrun simctl list | grep "${SIMULATOR}" | grep "unavailable" | wc -l` -eq 1 ]; then
			# delete unavailable simulator
			xcrun simctl list |
			grep "${SIMULATOR}" |
			grep "unavailable" |
			cut -d "(" -f 2 |
			cut -d ")" -f 1 |
			xargs xcrun simctl delete
			return -1
		else
			return 0
		fi
}

function ensure_simulator_available() {
	SIMULATOR=$1

	if simulator_available "${SIMULATOR}"; then
		echo "${SIMULATOR} exists"
		return
	fi

	DEVICE=`echo "${SIMULATOR}" | cut -d "/" -f 2`
	OS=`echo "${SIMULATOR}" | cut -d "/" -f 3`
	VERSION_SUFFIX=`echo "${SIMULATOR}" | cut -d "/" -f 4 | sed -e "s/\./-/"`

	RUNTIME="com.apple.CoreSimulator.SimRuntime.${OS}-${VERSION_SUFFIX}"

	echo "Creating new simulator"
	xcrun simctl create "${SIMULATOR}" "com.apple.CoreSimulator.SimDeviceType.${DEVICE}" "com.apple.CoreSimulator.SimRuntime.${OS}-${VERSION_SUFFIX}"
}

if runtime_available "com.apple.CoreSimulator.SimRuntime.iOS-9-1"; then
	DEFAULT_IOS9_SIMULATOR=RxSwiftTest/iPhone-6/iOS/9.1
else
	DEFAULT_IOS9_SIMULATOR=RxSwiftTest/iPhone-6/iOS/9.0
fi

BUILD_DIRECTORY=build

function rx() {
	SCHEME=$1
	CONFIGURATION=$2
	SIMULATOR=$3
	ACTION=$4

	echo
	printf "${GREEN}${ACTION} ${BOLDCYAN}$SCHEME - $CONFIGURATION ($SIMULATOR)${RESET}\n"
	echo

	DESTINATION=""
	if [ "${SIMULATOR}" != "" ]; then
			ensure_simulator_available "${SIMULATOR}"
			OS=`echo $SIMULATOR | cut -d '/' -f 3`
			SIMULATOR_GUID=`xcrun simctl list devices | grep ${SIMULATOR} | cut -d "(" -f 2 | cut -d ")" -f 1`
			DESTINATION='platform='$OS' Simulator,OS='$OS',id='$SIMULATOR_GUID''
			echo "Running on ${DESTINATION}"
	else
			DESTINATION='platform=OS X,arch=x86_64'
	fi

	STATUS=""
	xcodebuild -workspace Rx.xcworkspace \
				-scheme $SCHEME \
				-configuration $CONFIGURATION \
				-derivedDataPath "${BUILD_DIRECTORY}" \
				-destination "$DESTINATION" \
				$ACTION | xcpretty -c; STATUS=${PIPESTATUS[0]}

	if [ $STATUS -ne 0 ]; then
		echo $STATUS
 		exit $STATUS
	fi
}
