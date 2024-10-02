/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef LIBTEST_LIBTEST_H_
#define LIBTEST_LIBTEST_H_

#include <string>

#include "base/ntios_types.h"

using std::string;

#define CMD_START chr(0x02)
#define CMD_ENDCHAR chr(0x0d)
#define CMD_END "\n"

#define test_start "TST"
#define test_end "END"
#define test_cmd_echo "ECO"
#define test_cmd_log "LOG"
#define test_cmd_set_firmware "FWR"
#define test_set_var "VAR"
#define TEST_RESULT_PASSED "0"
#define TEST_RESULT_FAILED "1"

typedef struct {
  string cmd;
  string data;
} test_cmd;

void test_boot(U16 test_number);
void test_init_serial();
void test_init(string test_name);
void test_send_command(string command_id, string content);
void test_send_content(string content);
void test_finish(string notes);
void test_log(string msg);
void test_wait(S16 seconds);
void test_wait_ms(U32 ms);
test_cmd test_read_command();

#endif  // LIBTEST_LIBTEST_H_
