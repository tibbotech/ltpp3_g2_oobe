#!/usr/bin/expect -f
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# PAIR FROM LTPP3-G2 TO ANOTHER BT-DEVICE
# Remark:
# This means that the ltpp3-g2 sends a pair-request to other device
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#---Input args:
#expect_macAddr_input: MAC-Address of the Target BT-device
#expect_pinCode: Pin-code of the specified Target BT-device
#expect_scanTimeOut_base: Duration of the scan
set prompt "#"
set expect_macAddr_input [lindex $argv 0]
set expect_pinCode [lindex $argv 1]
set expect_scanTimeOut_base [lindex $argv 2]
set expect_loadBanner [lindex $argv 3]



#---Constants
set EXPECT_TITLE "TIBBO"

set EXPECT_EMPTYSTRING ""

#---Color Constants
set EXPECT_NOCOLOR "\33\[0m"
set EXPECT_FG_ORANGE "\33\[30;38;5;209m"
set EXPECT_FG_LIGHTRED "\33\[1;31m"
set EXPECT_FG_SOFLIGHTRED "\33\[30;38;5;131m"
set EXPECT_FG_YELLOW "\33\[1;33m"
set EXPECT_TIBBO_FG_WHITE "\33\[30;38;5;15m"
set EXPECT_FG_LIGHTGREEN "\33\[30;38;5;71m"
set EXPECT_FG_LIGHTGREY "\33\[30;38;5;246m"
set EXPECT_FG_LIGHTPINK "\33\[30;38;5;224m"

set EXPECT_TIBBO_BG_ORANGE "\33\[30;48;5;209m"

#---Numerical Constants
set EXPECT_ARGVTOTAL_INPUT [llength $argv]
set EXPECT_ARGVTOTAL_MAX 4
set EXPECT_RETRY_MAX 3

#---Boolean Constants
set EXPECT_TRUE "true"
set EXPECT_FALSE "false"


#---Pattern Constants
set EXPECT_ALREADYEXISTS_PATTERN "AlreadyExists"
set EXPECT_AUTHENTICATION_CANCELLED_PATTERN ".AuthenticationCanceled"
set EXPECT_AUTHENTICATION_FAILED_PATTERN "AuthenticationFailed"
set EXPECT_CONNECTION_ATTEMPT_FAILED_PATTERN "ConnectionAttemptFailed"
set EXPECT_CONTROLLER_PATTERN "Controller"
set EXPECT_NOT_AVAILABLE_PATTERN "not available"
set EXPECT_PAIRING_SUCCESSFUL_PATTERN "Pairing successful"
set EXPECT_REQUEST_CONFIRMATION_PATTERN "Request confirmation"
set EXPECT_REQUEST_PIN_CODE_PATTERN "Request PIN code"
set EXPECT_TRUST_SUCCEEDED_PATTERN "trust succeeded"

#---Print Constants
set EXPECT_PRINTF_ERROR_UNMATCHED_INPUT_ARGS ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: UNMATCHED INPUT ARGS:"
set EXPECT_PRINTF_ERROR_FAILED_TO_AUTHENTICATE_WITH ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: ${EXPECT_FG_LIGHTRED}FAILED${EXPECT_NOCOLOR} TO AUTHENTICATE WITH"
set EXPECT_PRINTF_ERROR_DEVICE_NOT_FOUND ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: DEVICE ${EXPECT_FG_LIGHTRED}NOT${EXPECT_NOCOLOR} FOUND..."
set EXPECT_PRINTF_ERROR_EXITING_NOW ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: EXITING NOW..."
set EXPECT_PRINTF_ERROR_FAILED_TRUST_WITH ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: ${EXPECT_FG_LIGHTRED}FAILED${EXPECT_NOCOLOR} TRUST WITH"
set EXPECT_PRINTF_ERROR_MAX_RETRY_EXCEEDED_FOR_MAC_ADDRESS ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: MAXIMUM RETRY EXCEEDED FOR MAC-ADDRESS"
set EXPECT_PRINTF_ERROR_NO_CONFIRMATION_RECEIVED_FROM_DEVICE ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: NO CONFIRMATION RECEIVED FROM DEVICE"
set EXPECT_PRINTF_ERROR_PINCODE_REQUIRED_NONE_PROVIDED ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: PINCODE REQUIRED...${EXPECT_FG_LIGHTRED}NONE${EXPECT_NOCOLOR} PROVIDED..."
set EXPECT_PRINTF_ERROR_WRONG_PINCODE ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: ${EXPECT_FG_LIGHTRED}WRONG${EXPECT_NOCOLOR} PIN-CODE"
set EXPECT_PRINTF_ERROR_FAILED_TO_PAIR_WITH ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: ${EXPECT_FG_LIGHTRED}FAILED${EXPECT_NOCOLOR} TO PAIR WITH"
set EXPECT_PRINTF_ERROR_NO_RESPONSE_FROM ":--*${EXPECT_FG_LIGHTRED}ERROR${EXPECT_NOCOLOR}: NO RESPONSE FROM"

set EXPECT_PRINTF_RETRY_ATTEMPT ":-->${EXPECT_FG_YELLOW}STATUS${EXPECT_NOCOLOR}: RETRY ATTEMPT:"

set EXPECT_CHECKMSG_ARG1_PHASE "MAC-ADDRESS (${EXPECT_FG_LIGHTPINK}arg1${EXPECT_NOCOLOR})"
set EXPECT_CHECKMSG_ARG2_PHASE "PIN-CODE (${EXPECT_FG_LIGHTPINK}arg2${EXPECT_NOCOLOR})"
set EXPECT_CHECKMSG_ARG3_PHASE "SCAN-TIMEOUT (${EXPECT_FG_LIGHTPINK}arg3${EXPECT_NOCOLOR})"
set EXPECT_CHECKMSG_ARG4_PHASE "LOAD-BANNER (${EXPECT_FG_LIGHTPINK}arg4${EXPECT_NOCOLOR})"
set EXPECT_CHECKMSG_ARG1_NO_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: ${EXPECT_CHECKMSG_ARG1_PHASE}: ${EXPECT_FG_LIGHTRED}NO${EXPECT_NOCOLOR} INPUT (e.g., AA:BB:CC:DD:EE:FF)"
set EXPECT_CHECKMSG_ARG2_NO_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: ${EXPECT_CHECKMSG_ARG2_PHASE}: ${EXPECT_FG_LIGHTRED}NO${EXPECT_NOCOLOR} INPUT"
set EXPECT_CHECKMSG_ARG3_NO_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: ${EXPECT_CHECKMSG_ARG3_PHASE}: ${EXPECT_FG_LIGHTRED}NO${EXPECT_NOCOLOR} INPUT (e.g., 1 - 255)"
set EXPECT_CHECKMSG_ARG4_NO_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: ${EXPECT_CHECKMSG_ARG4_PHASE}: ${EXPECT_FG_LIGHTRED}NO${EXPECT_NOCOLOR} INPUT (e.g., true, false)"
set EXPECT_CHECKMSG_ARG1_INVALID_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: MAC-ADDRESS (${EXPECT_FG_LIGHTPINK}arg1${EXPECT_NOCOLOR}): ${EXPECT_FG_LIGHTRED}INVALID${EXPECT_NOCOLOR} INPUT (e.g., AA:BB:CC:DD:EE:FF)"
set EXPECT_CHECKMSG_ARG2_NOT_A_NUMERIC_VALUE ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: PIN-CODE (${EXPECT_FG_LIGHTPINK}arg2${EXPECT_NOCOLOR}): ${EXPECT_FG_LIGHTRED}NOT${EXPECT_NOCOLOR} A NUMERIC VALUE"
set EXPECT_CHECKMSG_ARG3_VALUE_CAN_NOT_BE_ZERO ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: SCAN-TIMEOUT (${EXPECT_FG_LIGHTPINK}arg3${EXPECT_NOCOLOR}): CAN ${EXPECT_FG_LIGHTRED}NOT${EXPECT_NOCOLOR} BE '${EXPECT_FG_LIGHTGREY}0${EXPECT_NOCOLOR}' (e.g., 1 - 255)"
set EXPECT_CHECKMSG_ARG3_CAN_NOT_BE_GREATER_THAN_255 ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: SCAN-TIMEOUT (${EXPECT_FG_LIGHTPINK}arg3${EXPECT_NOCOLOR}): CAN ${EXPECT_FG_LIGHTRED}NOT${EXPECT_NOCOLOR} BE GREATER THAN '${EXPECT_FG_LIGHTGREY}255${EXPECT_NOCOLOR}' (e.g., 1 - 255)"
set EXPECT_CHECKMSG_ARG4_INVALID_INPUT ":-->${EXPECT_FG_ORANGE}CHECK${EXPECT_NOCOLOR}: LOAD-BANNER (${EXPECT_FG_LIGHTPINK}arg4${EXPECT_NOCOLOR}): ${EXPECT_FG_LIGHTRED}INVALID${EXPECT_NOCOLOR} INPUT (e.g., true, false)"
set EXPECT_PRINTF_EXITING_NOW ":-->${EXPECT_FG_ORANGE}STATUS${EXPECT_NOCOLOR}: EXITING NOW..."
set EXPECT_PRINTF_ALREADY_PAIRED_WITH ":-->${EXPECT_FG_ORANGE}STATUS${EXPECT_NOCOLOR}: ALREADY PAIRED WITH"
set EXPECT_PRINTF_SUCCESFFULY_PAIRED_WITH ":-->${EXPECT_FG_ORANGE}STATUS${EXPECT_NOCOLOR}: ${EXPECT_FG_LIGHTGREEN}SUCCESSFULLY${EXPECT_NOCOLOR} PAIRED WITH"
set EXPECT_PRINTF_PAIRING_WITH ":-->${EXPECT_FG_ORANGE}ACTION${EXPECT_NOCOLOR}: PAIRING WITH"
set EXPECT_PRINTF_REMOVING ":-->${EXPECT_FG_ORANGE}ACTION${EXPECT_NOCOLOR}: REMOVING"
set EXPECT_PRINTF_SCAN_ON ":-->${EXPECT_FG_ORANGE}ACTION${EXPECT_NOCOLOR}: SCAN: ${EXPECT_FG_LIGHTGREEN}ON${EXPECT_NOCOLOR}"
set EXPECT_PRINTF_SCAN_OFF ":-->${EXPECT_FG_ORANGE}ACTION${EXPECT_NOCOLOR}: SCAN: ${EXPECT_FG_SOFLIGHTRED}OFF${EXPECT_NOCOLOR}"
set EXPECT_PRINTF_TRUSTING ":-->${EXPECT_FG_ORANGE}ACTION${EXPECT_NOCOLOR}: TRUSTING"
set EXPECT_PRINTF_WAITING_FOR ":-->${EXPECT_FG_ORANGE}STATUS${EXPECT_NOCOLOR}: WAITING FOR"



#---Constants
set EXPECT_RETRY_MAX 3

#---Initialization
set exitCode 0
set expect_scanTimeOut_real 0
set expect_retry_param 0

set inputArgs_isError ${EXPECT_FALSE}



#---Header
if { [string compare ${expect_loadBanner} ${EXPECT_TRUE}] == 0 } {
    send_user "\n${EXPECT_TIBBO_BG_ORANGE}                                 ${EXPECT_TIBBO_FG_WHITE}${EXPECT_TITLE}${EXPECT_TIBBO_BG_ORANGE}                                ${EXPECT_NOCOLOR}\r\n\n"
}



#---Open 'bluetoothctl'
sleep 1
spawn bluetoothctl



#---Check the number of input args
if { $EXPECT_ARGVTOTAL_INPUT != $EXPECT_ARGVTOTAL_MAX } {
    send_user "\n${EXPECT_PRINTF_ERROR_UNMATCHED_INPUT_ARGS} (${EXPECT_FG_YELLOW}${EXPECT_ARGVTOTAL_INPUT}${EXPECT_NOCOLOR} out-of ${EXPECT_FG_YELLOW}${EXPECT_ARGVTOTAL_MAX}${EXPECT_NOCOLOR})\r"

    #Set boolean to TRUE
    #REMARK: this will prevent the message 'EXPECT_PRINTF_ERROR_MAX_RETRY_EXCEEDED_FOR_MAC_ADDRESS' from being shown
    set inputArgs_isError ${EXPECT_TRUE}

    #Set expect_retry_param=4 to Exit Loop
    set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

    #Set exit-code
    set exitCode 99

} else {
    if { [string compare ${expect_macAddr_input} ${EXPECT_EMPTYSTRING}] == 0 } {
        send_user "\n${EXPECT_CHECKMSG_ARG1_NO_INPUT}\r"

        #Set boolean to TRUE
        set inputArgs_isError ${EXPECT_TRUE}
    } else {
        #REMARK: by putting an EXCLAMATION MARK '!' in front of...
        #........the LEFT RECTANGULAR BRACKET '[' the 'if' changed to 'if NOT'
        if { ![ regexp {[0-9a-zA-Z][0-9a-zA-Z]:[0-9a-zA-Z][0-9a-zA-Z]:[0-9a-zA-Z][0-9a-zA-Z]:[0-9a-zA-Z][0-9a-zA-Z]:[0-9a-zA-Z][0-9a-zA-Z]:[0-9a-zA-Z][0-9a-zA-Z]} ${expect_macAddr_input} ] } {
            send_user "\n${EXPECT_CHECKMSG_ARG1_INVALID_INPUT}\r"

            #Set boolean to TRUE
            set inputArgs_isError ${EXPECT_TRUE}
        }  
    }
    #In case Pincode is NOT an Empty String
    if { [string compare ${expect_pinCode} ${EXPECT_EMPTYSTRING}] != 0 } {
        #Check if pin-code contains any non-numerical value(s)
        if { [ regexp {[a-zA-Z]} ${expect_pinCode} ] } {
            send_user "\n${EXPECT_CHECKMSG_ARG2_NOT_A_NUMERIC_VALUE}\r"

            #Set boolean to TRUE
            set inputArgs_isError ${EXPECT_TRUE}
        }
    }
    if { [string compare ${expect_scanTimeOut_base} ${EXPECT_EMPTYSTRING}] == 0 } {
        send_user "\n${EXPECT_CHECKMSG_ARG3_NO_INPUT}\r"

        #Set boolean to TRUE
        set inputArgs_isError ${EXPECT_TRUE}
    } else {
        if { ${expect_scanTimeOut_base} == 0} {
            send_user "\n${EXPECT_CHECKMSG_ARG3_VALUE_CAN_NOT_BE_ZERO}\r"

            #Set boolean to TRUE
            set inputArgs_isError ${EXPECT_TRUE}
        } elseif { ${expect_scanTimeOut_base} > 255 } {
            send_user "\n${EXPECT_CHECKMSG_ARG3_CAN_NOT_BE_GREATER_THAN_255}\r"

            #Set boolean to TRUE
            set inputArgs_isError ${EXPECT_TRUE}
        }
    }
    if { [string compare ${expect_loadBanner} ${EXPECT_EMPTYSTRING}] == 0 } {
        send_user "\n${EXPECT_CHECKMSG_ARG4_NO_INPUT}\r"

        #Set boolean to TRUE
        set inputArgs_isError ${EXPECT_TRUE}
    } else {
        if { [string compare ${expect_loadBanner} ${EXPECT_TRUE}] && [string compare ${expect_loadBanner} ${EXPECT_FALSE}] != 0 } {
            send_user "\n${EXPECT_CHECKMSG_ARG4_INVALID_INPUT}\r"

            #Set boolean to TRUE
            set inputArgs_isError ${EXPECT_TRUE}
        }
    }


    #In case an error occured
    if { [string compare ${inputArgs_isError} ${EXPECT_TRUE}] == 0 } {
        #Set boolean to TRUE
        set inputArgs_isError ${EXPECT_TRUE}

        #Set expect_retry_param=4 to Exit Loop
        set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];
    }
}

#---Start the TRUST & PAIR process
while true {
    #Reset boolean
    set expect_trust_succeeded_received_after_timeout "${EXPECT_FALSE}"

#---Check if retry paramenter 'expect_retry_param' has exceeded the maximum
    if { ${expect_retry_param} > ${EXPECT_RETRY_MAX} } {
        #Only print the message 'EXPECT_PRINTF_ERROR_MAX_RETRY_EXCEEDED_FOR_MAC_ADDRESS'...
        #...if the boolean is FALSE
        if { [string compare ${inputArgs_isError} ${EXPECT_FALSE}] == 0 } {
            send_user "\n${EXPECT_PRINTF_ERROR_MAX_RETRY_EXCEEDED_FOR_MAC_ADDRESS}\r"
        }

        send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
        send_user "\n\r"
        
        #Set expect_retry_param=4 to Exit Loop
        set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

        #Set exit-code
        set exitCode 99

        #Exit loop immediately
        break
    } else {
        send_user "\n${EXPECT_PRINTF_RETRY_ATTEMPT} ${EXPECT_FG_LIGHTGREY}${expect_retry_param}${EXPECT_NOCOLOR} out-of ${EXPECT_FG_LIGHTGREY}${EXPECT_RETRY_MAX}${EXPECT_NOCOLOR}\r"
    }


#---The following expect-condition is triggered if the 'expect reply'...
#---...is not received within a certain period amount of time.
    expect {
        ${EXPECT_TRUST_SUCCEEDED_PATTERN} {
            set expect_trust_succeeded_received_after_timeout "${EXPECT_TRUE}"
        }
        ${EXPECT_PAIRING_SUCCESSFUL_PATTERN} {
            send_user "\n${EXPECT_PRINTF_SUCCESFFULY_PAIRED_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
            send_user "\n${EXPECT_PRINTF_EXITING_NOW}\r"
            send_user "\n\r"

            #Set expect_retry_param=4 to Exit Loop
            set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

            #Set exit-code
            set exitCode 0

            #Exit loop immediately
            break
        }
        ${EXPECT_AUTHENTICATION_CANCELLED_PATTERN} {
            send_user "\n${EXPECT_PRINTF_ERROR_NO_RESPONSE_FROM} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"                     
        }
        ${EXPECT_AUTHENTICATION_FAILED_PATTERN} {
            send_user "\n${EXPECT_PRINTF_ERROR_NO_RESPONSE_FROM} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"                     
        }
        ${EXPECT_ALREADYEXISTS_PATTERN} {
            send_user "\n${EXPECT_PRINTF_ALREADY_PAIRED_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
            send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
            send_user "\n\r"

            #Set expect_retry_param=4 to Exit Loop
            set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

            #Set exit-code
            set exitCode 99

            #Exit loop immediately
            break                            
        }       
    }

    #Only execute the following condition if the 'trust succeeded' reply was NOT received after a certain period of time
    if { [string compare ${expect_trust_succeeded_received_after_timeout} ${EXPECT_FALSE}] == 0 } {
#-------Calculate the sleep-time:
        if { ${expect_retry_param} == 0 } {
            set expect_scanTimeOut_real ${expect_scanTimeOut_base}
        } else {
            set expect_scanTimeOut_real [expr ${expect_retry_param}*${expect_scanTimeOut_base}]
        }

#-------Remove MAC-address
        send_user "\n${EXPECT_PRINTF_REMOVING} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
        expect -re $prompt
        send "remove ${expect_macAddr_input}\r"
        sleep 1

#-------Scan: On
        send_user "\n${EXPECT_PRINTF_SCAN_ON}\r"
        expect -re $prompt
        send "scan on\r"

#-------Wait for a specified number seconds
        send_user "\n${EXPECT_PRINTF_WAITING_FOR} ${EXPECT_FG_LIGHTGREY}${expect_scanTimeOut_real}${EXPECT_NOCOLOR} SEC\r"
        sleep $expect_scanTimeOut_real

#-------Scan: Off
        send_user "\n${EXPECT_PRINTF_SCAN_OFF}\r"
        expect -re $prompt
        send "scan off\r"
        expect ${EXPECT_CONTROLLER_PATTERN}

        sleep 1
    }

#--->TRUST
    send_user "\n${EXPECT_PRINTF_TRUSTING} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
    expect -re $prompt
    send "trust ${expect_macAddr_input}\r"
    expect {
        ${EXPECT_TRUST_SUCCEEDED_PATTERN} { 
#----------->PAIR
            send_user "\n${EXPECT_PRINTF_PAIRING_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
            expect -re $prompt
            send "pair ${expect_macAddr_input}\r"
            expect {
                ${EXPECT_REQUEST_PIN_CODE_PATTERN} {
                    if { [string compare ${expect_pinCode} ${EXPECT_EMPTYSTRING}] == 0 } {
                        send_user "\n${EXPECT_PRINTF_ERROR_PINCODE_REQUIRED_NONE_PROVIDED}\r"
                        send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                        send_user "\n\r"

                        #Set expect_retry_param=4 to Exit Loop
                        set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                        #Set exit-code
                        set exitCode 99

                        #Exit loop immediately
                        break
                    } else {
                        expect -re $prompt
                        send "${expect_pinCode}\r"
                        sleep 2

                        expect {
                            ${EXPECT_PAIRING_SUCCESSFUL_PATTERN} {
                                send_user "\n${EXPECT_PRINTF_SUCCESFFULY_PAIRED_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                                send_user "\n${EXPECT_PRINTF_EXITING_NOW}\r"
                                send_user "\n\r"

                                #Set expect_retry_param=4 to Exit Loop
                                set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                                #Set exit-code
                                set exitCode 0
                                
                                #Exit loop immediately
                                break
                            }
                            ${EXPECT_AUTHENTICATION_FAILED_PATTERN} {
                                send_user "\n${EXPECT_PRINTF_ERROR_WRONG_PINCODE}\r"
                                send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                                send_user "\n\r"

                                #Set expect_retry_param=4 to Exit Loop
                                set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                                #Set exit-code
                                set exitCode 99
                                
                                #Exit loop immediately
                                break
                            }
                        }
                    }
                }
                ${EXPECT_REQUEST_CONFIRMATION_PATTERN} {
#-------------------CONFIRM PASSKEY
                    #This is the situation in which a Pin-code is not required, because...
                    #...upon receival of a 'pair-request', the receiving device...
                    #...will automatically send a 'confirmation passkey' to the LTPP3-G2.

                    expect -re $prompt
                    send "yes\r"
                    sleep 2

                    expect {
                        ${EXPECT_PAIRING_SUCCESSFUL_PATTERN} {
                            send_user "\n${EXPECT_PRINTF_SUCCESFFULY_PAIRED_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                            send_user "\n${EXPECT_PRINTF_EXITING_NOW}\r"
                            send_user "\n\r"

                            #Set expect_retry_param=4 to Exit Loop
                            set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                            #Set exit-code
                            set exitCode 0
                            
                            #Exit loop immediately
                            break
                        }
                        ${EXPECT_AUTHENTICATION_FAILED_PATTERN} {
                            send_user "\n${EXPECT_PRINTF_ERROR_FAILED_TO_AUTHENTICATE_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                            send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                            send_user "\n\r"

                            #Set expect_retry_param=4 to Exit Loop
                            set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                            #Set exit-code
                            set exitCode 99

                            #Exit loop immediately
                            break
                        }
                        default {
                            #This default-case is triggered when...
                            #...the LTPP3-G2 sends a pair-request to the another BT-device
                            #...but the BT-device does NOT respond within a certain period of time.
                            #Note: the 'expect' value is an 'EMPTY STRING'

#---------------------------INCREMENT RETRY COUNTER
                            incr expect_retry_param
                       }
                    }
                }
                ${EXPECT_AUTHENTICATION_FAILED_PATTERN} {
                    send_user "\n${EXPECT_PRINTF_ERROR_FAILED_TO_PAIR_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                    send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                    send_user "\n\r"

                    #Set expect_retry_param=4 to Exit Loop
                    set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                    #Set exit-code
                    set exitCode 99

                    #Exit loop immediately
                    break
                }
                ${EXPECT_CONNECTION_ATTEMPT_FAILED_PATTERN} {
                    send_user "\n${EXPECT_PRINTF_ERROR_FAILED_TO_PAIR_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                    send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                    send_user "\n\r"

                    #Set expect_retry_param=4 to Exit Loop
                    set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                    #Set exit-code
                    set exitCode 99
                    
                    #Exit loop immediately
                    break
                }
                ${EXPECT_NOT_AVAILABLE_PATTERN} {
                    send_user "\n${EXPECT_PRINTF_ERROR_FAILED_TO_PAIR_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"
                    send_user "\n${EXPECT_PRINTF_ERROR_EXITING_NOW}\r"
                    send_user "\n\r"

                    #Set expect_retry_param=4 to Exit Loop
                    set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                    #Set exit-code
                    set exitCode 99

                    #Exit loop immediately
                    break
                }
            }
        }
        ${EXPECT_NOT_AVAILABLE_PATTERN} {
            #REMARK:
            #   if 'trust with another BT-device' does NOT succeed after the 1st attempt, then...
            #...do NOT terminate 'bluetoothctl' right away,...
            #...instead retry 3 times before exiting.
            send_user "\n${EXPECT_PRINTF_ERROR_FAILED_TRUST_WITH} ${EXPECT_FG_LIGHTGREY}${expect_macAddr_input}${EXPECT_NOCOLOR}\r"

            if { ${expect_retry_param} < ${EXPECT_RETRY_MAX} } {
#---------------INCREMENT RETRY COUNTER
                incr expect_retry_param
            } else {
                #Set expect_retry_param=4 to Exit Loop
                set expect_retry_param [expr ${EXPECT_RETRY_MAX}+1];

                #Set exit-code
                set exitCode 99
            }
        }
    }
}



#Exit
sleep 1
send "quit\r"

#End-of-line
expect eof

#Exit-code
exit $exitCode