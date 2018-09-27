FROM dockerhub.iis.sinica.edu.tw/DNN-train:twgo

MAINTAINER sih4sing5hong5

ENV CPU_CORE 32

ENV SIANN_KALDI_S5C /usr/local/kaldi/egs/taiwanese/s5c
ENV KALDI_S5C /usr/local/kaldi/egs/formosa/s5

COPY --from=dockerhub.iis.sinica.edu.tw/gi2-gian5_boo5-hing5:204 $SIANN_KALDI_S5C/tshi3 $KALDI_S5C/tshi3
COPY --from=dockerhub.iis.sinica.edu.tw/gi2-gian5_boo5-hing5:204 $SIANN_KALDI_S5C/走評估.sh $KALDI_S5C/走評估.sh

WORKDIR $KALDI_S5C
RUN git pull
RUN bash -c 'rm -rf exp/{tri1,tri2,tri3,tri4}/decode_train_dev*'

RUN sed "s/nj\=[0-9]\+/nj\=${CPU_CORE}/g" -i 走評估.sh
COPY 走評估.sh .
RUN bash -c 'time bash -x 走評估nnet3.sh data/lang_free tshi3/train_free'

RUN bash -c 'time bash 看結果.sh' # tri4 nia
