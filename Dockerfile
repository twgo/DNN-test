ARG TSHI=215
FROM dockerhub.iis.sinica.edu.tw/gi2-gian5_boo5-hing5:${TSHI} as tsuliau

FROM dockerhub.iis.sinica.edu.tw/dnn-train:twgo

MAINTAINER sih4sing5hong5

ENV CPU_CORE 32

ENV SIANN_KALDI_S5C /usr/local/kaldi/egs/taiwanese/s5c
ENV KALDI_S5C /usr/local/kaldi/egs/formosa/s5


COPY --from=tsuliau $SIANN_KALDI_S5C/tshi3 $KALDI_S5C/tshi3
COPY --from=tsuliau /usr/local/pian7sik4_gi2liau7/kati_liokim /usr/local/pian7sik4_gi2liau7/kati_liokim

WORKDIR $KALDI_S5C

COPY --from=twgo/gi2gian5-boo5hing-hun3lian7 /opt/bun1.arpa .
COPY --from=twgo/gi2gian5-boo5hing-hun3lian7 /opt/bun3.arpa .
RUN gzip bun1.arpa && gzip bun3.arpa
RUN mkdir -p hethong/dict
RUN cp -r data/local/dict/[^l]* hethong/dict
COPY lexicon.txt lexicon_guan.txt
COPY error_silence error_silence
RUN cat error_silence.txt | sed 's/.*line //g' | sed 's/)/d/g' > error_cmd 
RUN sed -f error_cmd lexicon.txt | \
  cat > hethong/dict/lexicon.txt
RUN utils/prepare_lang.sh hethong/dict "<UNK>" hethong/local/lang_log hethong/lang_dict
RUN utils/format_lm.sh hethong/lang_dict bun1.arpa.gz hethong/dict/lexicon.txt hethong/lang
RUN utils/build_const_arpa_lm.sh bun3.arpa.gz hethong/lang hethong/lang-3grams


COPY character_tokenizer local/character_tokenizer
RUN wget -O 走評估nnet3.sh https://github.com/sih4sing5hong5/kaldi/raw/taiwanese/egs/taiwanese/s5c/%E8%B5%B0%E8%A9%95%E4%BC%B0nnet3.sh
RUN sed "s/nj\=[0-9]\+/nj\=${CPU_CORE}/g" -i 走評估nnet3.sh
RUN bash -c 'time bash -x 走評估nnet3.sh hethong/lang tshi3/train'
RUN steps/lmrescore_const_arpa.sh \
  hethong/lang hethong/lang-3grams \
  tshi3/train exp/chain/tdnn_1a_sp/decode_train_dev exp/chain/tdnn_1a_sp/decode_train_dev_rescoring

RUN bash -c 'cat exp/chain/tdnn_1a_sp/decode_train_dev_rescoring/wer_* | grep WER | ./utils/best_wer.sh'
RUN bash -c 'cat exp/chain/tdnn_1a_sp/decode_train_dev_rescoring/cer_* | grep WER | ./utils/best_wer.sh' | sed 's/WER/SER/g'
CMD bash -c 'cat exp/chain/tdnn_1a_sp/decode_train_dev_rescoring/wer_* | grep WER | ./utils/best_wer.sh'

