/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef BASE_NTIOS_LOG_H_
#define BASE_NTIOS_LOG_H_

#include <cstdio>
#include <string>

namespace ntios {
namespace base {

// Thank you Kenny Kerr this is useful.
// Why??? Because we want printf like syntax cout sucks for some things.
// To allow the magic of C++ we want to wrap the arguments.
template <typename T>
T Argument(T value) noexcept {
  return value;
}

/* Via the magic of C++ the String object will
   return its pointer to its string buffer.*/
template <typename T>
T const *Argument(std::basic_string<T> const &value) noexcept {
  return value.c_str();
}

namespace logging {
static const char *DbgColorRed = "\x1B[1;31m";
/** Green color for tag output.  */
static const char *DbgColorGreen = "\x1B[1;32m";
/** Yellow color for tag output.  */
static const char *DbgColorYellow = "\x1B[1;33m";
/** Blue color for tag output.  */
static const char *DbgColorBlue = "\x1B[1;34m";
/** Magenta color for tag output.  */
static const char *DbgColorMagenta = "\x1B[1;35m";
/** CYAN color for tag output.  */
static const char *DbgColorCyan = "\x1B[1;36m";
/** Default color for tag output.  */
static const char *DbgColorReset = "\x1B[0m";

enum class logerrors { invalid_file };

class Logger {
 private:
  FILE *destination = NULL;
  std::string tag;

 public:
  bool enabled;
  Logger(std::string tag, std::string filename);

  Logger(std::string tag, FILE *file);

  ~Logger();

  Logger &operator=(const Logger &other);

  Logger(const Logger &) = delete;

  template <typename... Args>
  void Write(char const *const format, Args const &...args) noexcept {
    if (enabled) {
      fprintf(destination, /* Flawfinder: ignore */
              format, ntios::base::Argument(args)...);
    }
  }

  // Using the magic of C++ it will use the correct overload (wide or ascii)
  template <typename T>
  void Write(std::basic_string<T> const &value) noexcept {
    if (enabled) {
      Write(value.c_str());
    }
  }

  void Write(char const *const value) noexcept;
  void Write(wchar_t const *const value) noexcept;
  void Log(const char *color, const char *msg) noexcept;

  template <typename... Args>
  void Logf(const char *color, const char *format,
            Args const &...args) noexcept {
    if (enabled) {
      Write((color + tag + ": " + format + logging::DbgColorReset + "\r\n")
                .c_str(),
            ntios::base::Argument(args)...);
    }
  }

  void LogFatal(const char *msg) noexcept;

  template <typename... Args>
  void LogFatalF(const char *format, Args const &...args) noexcept {
    if (enabled) {
      Write(logging::DbgColorRed + ("DEADBEEF " + this->tag) + ": " + format +
                logging::DbgColorReset + "\r\n",
            ntios::base::Argument(args)...);
    }
  }
};
}  // namespace logging

namespace Helpers {

template <typename... Args>
int StringPrint(char *const buffer, size_t const bufferCount,
                char const *const format, Args const &...args) noexcept;

//
template <typename... Args>
int StringPrint(wchar_t *const buffer, size_t const bufferCount,
                wchar_t const *const format, Args const &...args) noexcept;

template <typename T, typename... Args>
void Format(std::basic_string<T> &buffer, T const *const format,  // NOLINT
            Args const &...args);

std::string ToString(wchar_t const *value);

std::string ToString(double const value, unsigned int const precision);

}  // namespace Helpers
}  // namespace base
}  // namespace ntios

#endif  // BASE_NTIOS_LOG_H_
