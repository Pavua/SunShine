#include "logging.h"
#include "tests_common.h"

#include <tuple>

using LogLevelTuple = std::tuple<const char *, boost::log::sources::severity_logger<int> *>;

static const LogLevelTuple log_levels[] = {
  {"trace", &trace},
  {"debug", &debug},
  {"info", &info},
  {"warning", &warning},
  {"error", &log_error},
  {"fatal", &fatal}};

struct LogLevelsTest : public testing::TestWithParam<LogLevelTuple> {
};

INSTANTIATE_TEST_SUITE_P(
  Logging,
  LogLevelsTest,
  testing::ValuesIn(log_levels),
  [](const auto &info) {
    return std::string(std::get<0>(info.param));
  });

TEST_P(LogLevelsTest, PutMessage) {
  auto [label, plogger] = GetParam();

  logging::init(true, "", "");
  BOOST_LOG(*plogger) << "Hello";
  logging::cleanup();
} 