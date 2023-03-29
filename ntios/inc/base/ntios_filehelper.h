#ifndef NTIOS_LINUX_SHARED_BASE_NTIOS_FILEHELPER_H_
#define NTIOS_LINUX_SHARED_BASE_NTIOS_FILEHELPER_H_

#include <string>

namespace ntios {
namespace base {
namespace file {

using std::string;

class FileHelper {
 public:
  /**
   * @brief
   *
   * @param targetDir Checks whether the specified directory exists or not.
   * @return true: the specified directory exists.
   *         false: the specified directory does not exist.
   */
  static bool DirExists(const string &targetDir);

  /**
   * @brief Gets the file content for a specified file fullpath.
   *
   * @param targetFpath the fullpath of the file from which the content needs to
   *                    be retrieved.
   * @return string containing the file-content of the specified targetFpath.
   */
  static string GetFileContent(const string &targetFpath);

  /**
   * @brief Writes a specified value (whether int-type or string-type) to a
   *        specified file fullpath.
   *
   * @param targetFpath the fullpath of the file to which the content needs to
   *                    be written to
   * @param value the contents to put in the file.
   */
  static void WriteToFile(const string &targetFpath, const string &value);

};  // class FileHelper

}  // namespace file
}  // namespace base
}  // namespace ntios

#endif