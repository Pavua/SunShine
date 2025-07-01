#include "logging.h"
#include <memory>
#include <stdexcept>

extern "C" {
#include <libswresample/swresample.h>
#include <libavutil/opt.h>
#include <libavutil/channel_layout.h>
#include <libavutil/error.h>
}

// Self-contained class to avoid needing a separate header
class av_stream_convert {
public:
  av_stream_convert();
  ~av_stream_convert();

  void init(
    long long int out_ch_layout,
    AVSampleFormat out_sample_fmt,
    int out_sample_rate,
    long long int in_ch_layout,
    AVSampleFormat in_sample_fmt,
    int in_sample_rate);
    
  int convert(const AVFrame *in_frame, uint8_t **out_data, int out_samples);

private:
  struct SwrContextDeleter {
    void operator()(SwrContext *ctx) const {
      swr_free(&ctx);
    }
  };
  std::unique_ptr<SwrContext, SwrContextDeleter> swr_ctx;
};


av_stream_convert::av_stream_convert() = default;
av_stream_convert::~av_stream_convert() = default;

void av_stream_convert::init(
  long long int out_ch_layout,
  AVSampleFormat out_sample_fmt,
  int out_sample_rate,
  long long int in_ch_layout,
  AVSampleFormat in_sample_fmt,
  int in_sample_rate) {

  SwrContext *ctx = swr_alloc_set_opts(
    nullptr,
    out_ch_layout, out_sample_fmt, out_sample_rate,
    in_ch_layout, in_sample_fmt, in_sample_rate,
    0, nullptr);

  if (!ctx) {
    BOOST_LOG(log_error) << "Could not create conversion context";
    throw std::runtime_error("Could not create conversion context");
  }
  swr_ctx.reset(ctx);

  int ret = swr_init(swr_ctx.get());
  if (ret < 0) {
    char err_buf[AV_ERROR_MAX_STRING_SIZE] = {0};
    BOOST_LOG(log_error) << "Could not initialize conversion context: " << av_make_error_string(err_buf, sizeof(err_buf), ret);
    throw std::runtime_error("Could not initialize resampler context");
  }
}

int av_stream_convert::convert(const AVFrame *in_frame, uint8_t **out_data, int out_samples) {
    if (!swr_ctx) {
        return AVERROR(EINVAL);
    }
    return swr_convert(swr_ctx.get(), out_data, out_samples, (const uint8_t **)in_frame->data, in_frame->nb_samples);
} 