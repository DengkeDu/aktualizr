#ifndef AKTUALIZR_SECONDARY_CONFIG_H_
#define AKTUALIZR_SECONDARY_CONFIG_H_

#include <boost/filesystem.hpp>
#include <boost/program_options.hpp>
#include <boost/property_tree/ini_parser.hpp>

// Uses StorageConfig from aktualizr
#include "config.h"

struct AktualizrSecondaryNetConfig {
  int port{9030};
  bool discovery{true};
  int discovery_port{9031};
};

struct AktualizrSecondaryUptaneConfig {
  std::string ecu_serial;
  std::string ecu_hardware_id;
};

class AktualizrSecondaryConfig {
 public:
  AktualizrSecondaryConfig() {}
  AktualizrSecondaryConfig(const boost::filesystem::path& filename, const boost::program_options::variables_map& cmd);
  AktualizrSecondaryConfig(const boost::filesystem::path& filename);

  void writeToFile(const boost::filesystem::path& filename);

  AktualizrSecondaryNetConfig network;
  StorageConfig storage;

 private:
  void updateFromCommandLine(const boost::program_options::variables_map& cmd);
  void updateFromPropertyTree(const boost::property_tree::ptree& pt);
  void updateFromToml(const boost::filesystem::path& filename);
};

#endif  // AKTUALIZR_SECONDARY_CONFIG_H_
