FROM dockerhub.iis.sinica.edu.tw/DNN-train:twgo

MAINTAINER sih4sing5hong5

ENV CPU_CORE 32

ENV SIANN_KALDI_S5C /usr/local/kaldi/egs/taiwanese/s5c
ENV KALDI_S5C /usr/local/kaldi/egs/formosa/s5

COPY --from=dockerhub.iis.sinica.edu.tw/gi2-gian5_boo5-hing5:204 $SIANN_KALDI_S5C/tshi3 $KALDI_S5C/tshi3

WORKDIR $KALDI_S5C

RUN wget -O 走評估nnet3.sh https://github.com/sih4sing5hong5/kaldi/raw/taiwanese/egs/taiwanese/s5c/%E8%B5%B0%E8%A9%95%E4%BC%B0nnet3.sh
RUN sed "s/nj\=[0-9]\+/nj\=${CPU_CORE}/g" -i 走評估nnet3.sh
RUN bash -c 'time bash -x 走評估nnet3.sh data/lang_free tshi3/train_free'

RUN bash -c 'cat exp/chain/tdnn_1a_sp/decode_train_dev/wer_* | grep WER | ./utils/best_wer.sh'
CMD bash -c 'cat exp/chain/tdnn_1a_sp/decode_train_dev/wer_* | grep WER | ./utils/best_wer.sh'

