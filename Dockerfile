FROM dockerhub.iis.sinica.edu.tw/siann1-hak8_boo5-hing5:203

MAINTAINER sih4sing5hong5

ENV CPU_CORE 32

##  匯入語料
WORKDIR /usr/local/pian7sik4_gi2liau7/
RUN git pull # 0828

WORKDIR /usr/local/hok8-bu7/
RUN rm -rf db.sqlite3

RUN echo 0828
RUN pip3 install --upgrade https://github.com/twgo/twisas/archive/master.zip
COPY twisas2.json /usr/local/gi2_liau7_khoo3/twisas2.json 

RUN python3 manage.py migrate
RUN python3 manage.py 匯入台文語料庫2版 本調 valid /usr/local/gi2_liau7_khoo3/twisas2.json
RUN python3 manage.py 匯入台文語料庫2版 本調 test /usr/local/gi2_liau7_khoo3/twisas2.json
RUN python3 manage.py 匯入台文語料庫trs 本調 valid /usr/local/pian7sik4_gi2liau7/twisas-trs/twisas-HL-kaldi.json
RUN python3 manage.py 匯入台文語料庫trs 本調 test /usr/local/pian7sik4_gi2liau7/twisas-trs/twisas-HL-kaldi.json


## 匯出語料
RUN pip3 install --upgrade https://github.com/i3thuan5/tai5-uan5_gian5-gi2_hok8-bu7/archive/kaldi%E7%94%A8%E6%B8%85%E6%B0%A3%E7%9A%84%E5%8F%A5.zip

RUN python3 manage.py 匯出Kaldi格式資料 --資料夾 tshi3 臺語 拆做聲韻 $KALDI_S5C
RUN python3 manage.py 轉Kaldi音節text 臺語 $KALDI_S5C/tshi3/train/ $KALDI_S5C/tshi3/train_free

WORKDIR $KALDI_S5C
RUN git pull
RUN bash -c 'rm -rf exp/{tri1,tri2,tri3,tri4}/decode_train_dev*'

#RUN sed 's/nj\=[0-9]\+/nj\=54/g' -i 走評估.sh
COPY 走評估.sh .
RUN bash -c 'time bash -x 走評估.sh data/lang_free tshi3/train_free'

RUN bash -c 'time bash 看結果.sh' # tri4 nia
