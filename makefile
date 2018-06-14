# 生成されるバイナリファイルの出力ディレクトリ
TARGETDIR = ./bin
# ソースコードの位置
SRCROOT   = ./src
# 中間バイナリファイルの出力ディレクトリ
OBJROOT   = ./bin
# ソースディレクトリの中を(shellの)findコマンドで走破してサブディレクトリまでリスト化する
SRCDIRS  := $(shell find $(SRCROOT) -type d)
# ソースディレクトリを元にforeach命令で全goファイルをリスト化する
SOURCES   = $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.go))
# 上記のgoファイルのリストを元に実行ファイル名を決定
TARGETS   = $(patsubst $(SRCROOT)%.go, $(TARGETDIR)%, $(SOURCES))
# シンボリックリンク名のリスト
SYMBOLS   = $(foreach dir, $(TARGETS), $(shell basename $(dir)))

build: $(TARGETS)

$(TARGETDIR)/%: $(SRCROOT)/%.go
	@if [ ! -e `dirname $@` ]; then mkdir -p `dirname $@`; fi
	go build -o $@ $<
	@if [ ! -e $(TARGETDIR)/$(shell basename $@) ]; then ln $@ $(TARGETDIR)/$(shell basename $@); fi

init:
	@if [ ! -e ./bin ]; then mkdir ./bin; fi

clean:
	rm -rf $(TARGETDIR)
	mkdir $(TARGETDIR)
