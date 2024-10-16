# encoding: utf-8
#
# Copyright (c) 2017 Department of Molecular and Cellular Bioanalysis,
# Graduate School of Pharmaceutical Sciences,
# Kyoto University. All rights reserved.
#


=begin
-----------------------------------------------------------------------------
	DistinctSearchResult.rb

	複数ピークリスト、複数サーチエンジンで検索した結果を
	ScanNoでマージし、Seq+ModDetailが同じものの重複を無くす。
	複数のピークリストがある場合はjPOSTscoreが良いピークリストの方を
	最終的な結果として残す。

	また、ValiableModの修飾があるものは
	ニュートラルロスが、ちゃんとあるかを再チェックして
	ニュートラルロスの無いものを「削除フラグ」をONにする。

	各検索エンジン毎のScore,PeptExpt,ModDetail,ProtKey,SearchEngine は
	別のカラムにして、それぞれのデータを残す。
	PeptExp等の今までのカラムには一番良いHitのものを残す。

	作成日 2017-05-17 taba
-----------------------------------------------------------------------------
=end

begin
	require('csv')
	require('json')

	require("../../CommonLib/ClassCommon1.12.rb")
	require("../../CommonLib/ClassUtility0.20.rb")
	require("../../CommonLib/ClassSeqTools0.12.rb")
	require("./Configure.rb")
	require("./ClassDistinctSearchResult.rb")
	require("./GetParamData.rb")


	# 入力パラメータの取り出し
	if(ARGV.length == 4)

		# JobRequestからの要求
		(paraItem,inFile,
		outFile,tmpFile,splitFile) = MyTools.getInParam(
			JobObjName::DIS_SEARCH_RESULT,
			ARGV,
			[ReqFileType::TYPE_FILTER_RESULT],
			[ReqFileType::TYPE_FILTER_RESULT],
			nil
		)

		if(inFile[ReqFileType::TYPE_FILTER_RESULT].kind_of?(String) == true)
			inFileAry = [inFile[ReqFileType::TYPE_FILTER_RESULT]]
		else
			inFileAry = inFile[ReqFileType::TYPE_FILTER_RESULT]
		end
		outFile = outFile[ReqFileType::TYPE_FILTER_RESULT]

		inFileType = paraItem[DisSRconst::DSR_IN_FILE_TYPE]
#		ms2PeakSelect = paraItem[DisSRconst::DSR_MS2_PEAK_SELECT]
		ms2PeakSelectBin = paraItem[DisSRconst::DSR_MS2_PEAK_SELECT_BIN]
		binRange = paraItem[DisSRconst::DSR_MS2_BIN_MZ_RANGE].to_i()
		plistMzNum = paraItem[DisSRconst::DSR_PL_MZ_NUM].to_i()
		maxFlagCharge = paraItem[DisSRconst::DSR_MAX_FLAG_CHG].to_i()
		ms2TolL = paraItem[DisSRconst::DSR_MS2_TOL_L].to_f()
		ms2TolR = paraItem[DisSRconst::DSR_MS2_TOL_R].to_f()
		ms2TolMainL = paraItem[DisSRconst::DSR_MAIN_MS2_TOL_L].to_f()
		ms2TolMainR = paraItem[DisSRconst::DSR_MAIN_MS2_TOL_R].to_f()
		ms2TolU = paraItem[DisSRconst::DSR_MS2_TOLU]
		ms2IonKindAry = paraItem[DisSRconst::DSR_ION_KIND].split(',')
		jPostScoreMin = paraItem[DisSRconst::DSR_MIN_J_SCORE].to_f()
		ms2KeyType = paraItem[DisSRconst::DSR_MS2_PEAK_KEY]
		psmUkey = paraItem[DisSRconst::DSR_PSM_U_KEY]
		uniScCst = paraItem[DisSRconst::DSR_UNI_SC_CONST]

		paraItem = nil

	elsif(ARGV.length == 17)

		# コマンドラインからの要求１（inFileが１つの場合）
		# Usage inFileType psmUkey ms2PeakSelectBin binRange plistMzNum  maxFlagChg ms2TolL ms2TolR ms2TolMainL ms2TolMainR ms2TolU ms2IonKindAry jPOSTscoreMin ms2KeyType uniScCst inFile outFile.

		inFileType = ARGV[0]
#		ms2PeakSelect = ARGV[1]
		psmUkey = ARGV[1]
		ms2PeakSelectBin = ARGV[2]
		binRange = ARGV[3].to_i()
		plistMzNum = ARGV[4].to_i()
		maxFlagCharge = ARGV[5].to_i()
		ms2TolL = ARGV[6].to_f()
		ms2TolR = ARGV[7].to_f()
		ms2TolMainL = ARGV[8].to_f()
		ms2TolMainR = ARGV[9].to_f()
		ms2TolU = ARGV[10]
		ms2IonKindAry = ARGV[11].split(',')
		jPostScoreMin = ARGV[12].to_f()
		ms2KeyType = ARGV[13]
		uniScCst = ARGV[14]

		inFileAry = [ARGV[15]]
		outFile = ARGV[16]


	elsif(ARGV.length == 16)

		# コマンドラインからの要求２（inFileが複数の場合）
		#  Usage inFileType psmUkey ms2PeakSelectBin binRange plistMzNum maxFlagChg ms2TolL ms2TolR ms2TolMainL ms2TolMainR ms2TolU ms2IonKindAry jPOSTscoreMin ms2KeyType inOutFile.json.

		inFileType = ARGV[0]
#		ms2PeakSelect = ARGV[1]
		psmUkey = ARGV[1]
		ms2PeakSelectBin = ARGV[2]
		binRange = ARGV[3].to_i()
		plistMzNum = ARGV[4].to_i()
		maxFlagCharge = ARGV[5].to_i()
		ms2TolL = ARGV[6].to_f()
		ms2TolR = ARGV[7].to_f()
		ms2TolMainL = ARGV[8].to_f()
		ms2TolMainR = ARGV[9].to_f()
		ms2TolU = ARGV[10]
		ms2IonKindAry = ARGV[11].split(',')
		jPostScoreMin = ARGV[12].to_f()
		ms2KeyType = ARGV[13]
		uniScCst = ARGV[14]

		# inOutFile.jsonの読み出し
		jsonStr = File.read(ARGV[15])

		inOutFileObj = JSON.parse(jsonStr)
		jsonStr = nil

		inFileAry = inOutFileObj['inFileAry']
		outFile = inOutFileObj['outFile']
		inOutFileObj = nil

	else
		p ARGV
		MyTools.printfAndExit(1,"#{__FILE__} : Line = #{__LINE__} : Usage JobGroup JobTreeKey ParamFileName.",caller(0))
	end
#p inFileAry
#p outFile
#p inFileType
#p ms2PeakSelect
#p ms2PeakSelectBin
#p binRange
#p plistMzNum
#p ms2TolL
#p ms2TolR
#p ms2TolU
#p ms2IonKindAry
#p jPostScoreMin
#p ms2KeyType
#p psmUkey
#p ms2TolMainL
#p ms2TolMainR
#p maxFlagCharge
#p uniScCst
#exit(0)


	# UniScore計算時の定数のパラメータを取得する
	(bothMatchConst,singleMatchConst,bothUnMatchConst,tagHitConst,noTagHitConst) = uniScCst.split(',')
	if(noTagHitConst == nil)
		MyTools.printfAndExit(1,"#{DisSRconst::DSR_UNI_SC_CONST} is mistake.",caller(0))
	end
	uniScCstAry = [
		bothMatchConst.to_f(),
		singleMatchConst.to_f(),
		bothUnMatchConst.to_f(),
		tagHitConst.to_f(),
		noTagHitConst.to_f(),
=begin
		bothMatchConst.to_i(),
		singleMatchConst.to_i(),
		bothUnMatchConst.to_i(),
		tagHitConst.to_i(),
		noTagHitConst.to_i(),
=end
	]
	bothMatchConst = nil
	singleMatchConst = nil
	bothUnMatchConst = nil
	tagHitConst = nil
	noTagHitConst = nil
	uniScCst = nil
#p uniScCstAry
#exit(0)

	outDirName = File.dirname(outFile)
	outFile = File.realpath(outDirName) + "/" + File.basename(outFile)
#	p outFile
#	exit(0)

	# 出力ファイルのディレクトリーが存在しなかったら作成する
	MyTools.createNoExistsDir(File.dirname(outDirName))


	# 酵素切断したSeqの部分配列の個数を数えたデータファイルの定義
	pepCountFile = './HUMAN_Trypsin_PepCount.json'


	# 結果保存用の変数を初期化
	fileNoTitleAry = {}
	scanNoHit = {}


	# inFileAryの中の結果ファイルを読み込む
	inFileAry.each_index{|aFileNo|
#p aFileNo
p inFileAry[aFileNo]

		# 入力のCsvFileを読み込む
		execObj = CsvFileToArray.new()
		execObj.setInFile(File.realpath(inFileAry[aFileNo]))
		csvDataTemp = execObj.exec()
		titleAryTemp = execObj.getTitleAry()
		execObj = nil
#p titleAryTemp
#exit(0)


		# 必要なタイトルがあるかをチェック
		DisSRtools.chekcHashKey(csvDataTemp,[
			ReqFileType::CSV_PEAK_COMMENT,
			ReqFileType::CSV_SEQ,
			ReqFileType::CSV_CHARGE,
			ReqFileType::CSV_MOD_DETAIL,
			ReqFileType::CSV_PEAK_LIST_FILE,
			ReqFileType::CSV_SEARCH_ENGINE,
			ReqFileType::CSV_PEPT_SCORE,
			ReqFileType::CSV_PEPT_EXPT,
		])


		# scanNo毎にユニークなHitペプチドの情報を作成する
		execObj = ScanNoHitGroup.new()
		execObj.setInFileNo(aFileNo)
		execObj.setCsvData(csvDataTemp)
		execObj.setTitleAry(titleAryTemp)
		execObj.setScanNoHit(scanNoHit)
		execObj.setTcomm(ReqFileType::CSV_PEAK_COMMENT)
		execObj.setTseq(ReqFileType::CSV_SEQ)
		execObj.setTcharge(ReqFileType::CSV_CHARGE)
		execObj.setTmodDetail(ReqFileType::CSV_MOD_DETAIL)
		execObj.setTplist(ReqFileType::CSV_PEAK_LIST_FILE)
		execObj.setTengine(ReqFileType::CSV_SEARCH_ENGINE)
		execObj.setTpepScore(ReqFileType::CSV_PEPT_SCORE)
		execObj.setTpepExpt(ReqFileType::CSV_PEPT_EXPT)
		execObj.setPsmUkey(psmUkey)
		execObj.exec()
		execObj = nil

		fileNoTitleAry[aFileNo] = DisSRtools.convValHash(titleAryTemp)
	}

# sortするのをやめる。
#	scanNoHit = scanNoHit.sort{|a,b|
#		(aKey,aValAry) = a
#		(bKey,bValAry) = b
#		aValAry[0] <=> bValAry[0]
#	}

#p fileNoTitleAry
#p scanNoHit
#exit(0)

	puts "Hit peptide+ModDetail count:#{scanNoHit.length}"


	# 全てのHitを集約したscanNoHitから、各ピークリストで
	# BestHitになったCommentの情報を作成する。
	plistComHash = DisSRtools.crePlistComHash(
		scanNoHit,
		fileNoTitleAry,
		ReqFileType::CSV_PEAK_LIST_FILE,
		ReqFileType::CSV_PEAK_COMMENT,
		ms2KeyType,
	)

#p plistComHash.keys()
#exit(0)


	# jPOSTscoreを計算するためのピークリストを作成する。
	ms2FlagAry = {}
	plistComHash.each{|aPlistFile,aComHash|
p aPlistFile
		execObj = PlistToMs2Data.new()
		execObj.setInFile(aPlistFile)
		execObj.setComHash(aComHash)
		execObj.setMs2KeyType(ms2KeyType)
		rtc = execObj.exec()
		execObj = nil

		ms2FlagAry[aPlistFile] = rtc
	}
	plistComHash = nil
#p ms2FlagAry
#exit(0)
	puts "PlistToMs2Data() end."


	# jPOSTscoreとHitフラグメント付属情報を計算する。
	# あと、jPOSTscore計算時に使うニュートラルロスのHitフラグメント
	# 情報を使い、ModDetailの修飾ポイントが正しいかのバリテーションを行う。
	# その結果をスコア値として保存する。
	# inFileTypeがDecoyモードの場合は、修飾ポイントが正しいかの
	# バリテーションチェックは不要。

	# プレjPOSTscore計算
	execObj = CalcjPOSTscore.new()
	execObj.setScanNoHit(scanNoHit)
	execObj.setMs2FlagAry(ms2FlagAry)
	execObj.setFileNoTitleAry(fileNoTitleAry)
	execObj.setMs2TolL(ms2TolL)
	execObj.setMs2TolR(ms2TolR)
	execObj.setMs2TolU(ms2TolU)
	execObj.setMs2IonKindAry(ms2IonKindAry)
	execObj.setInFileType(inFileType)
	execObj.setMs2KeyType(ms2KeyType)
	execObj.setTseq(ReqFileType::CSV_SEQ)
	execObj.setTmodDetail(ReqFileType::CSV_MOD_DETAIL)
	execObj.setTcharge(ReqFileType::CSV_CHARGE)
	execObj.setTpeakList(ReqFileType::CSV_PEAK_LIST_FILE)
	execObj.setTcomm(ReqFileType::CSV_PEAK_COMMENT)
	execObj.setTcalcMz(ReqFileType::CSV_CALC_MZ)
	execObj.setPepCountFile(pepCountFile)
	execObj.setJpostScoreMin(jPostScoreMin)
	execObj.setKeyToJpostScore(nil)
	execObj.setMs2PeakSelectBin(ms2PeakSelectBin)
	execObj.setBinRange(binRange)
	execObj.setPlistMzNum(plistMzNum)
	execObj.setMaxFlagCharge(maxFlagCharge)
	execObj.setUniScCstAry(uniScCstAry)
	(jpostScoreAry,maxTagLen,keyToJpostScore) = execObj.exec()
	execObj = nil
	binNumAry = nil
	peakNumAry = nil
#p jpostScoreAry
#p keyToJpostScore
#p maxTagLen
#exit(0)

	puts "Pre CalcjPOSTscore() end."


# TagScoreの評価のために一時的にコメント化 2019-04-26 taba
=begin
	jpostScoreAry = nil
	maxTagLen = nil

	# jPOSTscoreの大きいもの順でsort
	keyToJpostScore = keyToJpostScore.sort{|(k1, v1), (k2, v2)|
		v2[0] <=> v1[0]
	}
	keyToJpostScore = Hash[keyToJpostScore]
#p "zzz"
#p keyToJpostScore
#exit(0)

	# 本番jPOSTscore計算
	execObj = CalcjPOSTscore.new()
	execObj.setScanNoHit(scanNoHit)
	execObj.setMs2FlagAry(ms2FlagAry)
	execObj.setFileNoTitleAry(fileNoTitleAry)
	execObj.setMs2TolL(ms2TolMainL)
	execObj.setMs2TolR(ms2TolMainR)
	execObj.setMs2TolU(ms2TolU)
	execObj.setMs2IonKindAry(ms2IonKindAry)
	execObj.setInFileType(inFileType)
	execObj.setMs2KeyType(ms2KeyType)
	execObj.setTseq(ReqFileType::CSV_SEQ)
	execObj.setTmodDetail(ReqFileType::CSV_MOD_DETAIL)
	execObj.setTcharge(ReqFileType::CSV_CHARGE)
	execObj.setTpeakList(ReqFileType::CSV_PEAK_LIST_FILE)
	execObj.setTcomm(ReqFileType::CSV_PEAK_COMMENT)
	execObj.setPepCountFile(pepCountFile)
	execObj.setJpostScoreMin(jPostScoreMin)
	execObj.setKeyToJpostScore(keyToJpostScore)
	execObj.setMs2PeakSelectBin(ms2PeakSelectBin)
	execObj.setBinRange(binRange)
	execObj.setPlistMzNum(plistMzNum)
	execObj.setMaxCharge(maxFlagCharge)
	execObj.setUniScCstAry(uniScCstAry)
	(jpostScoreAry,maxTagLen,keyToJpostScore) = execObj.exec()
#p keyToJpostScore
#p maxTagLen
#exit(0)

	execObj = nil
	ms2FlagAry = nil
	keyToJpostScore = nil

=end
# TagScoreの評価のために一時的にコメント化 2019-04-26 taba



	# ImmoniumIonのHitフラグメントのサーチ
	execObj = SearchImmoniumIon.new()
	execObj.setScanNoHit(scanNoHit)
	execObj.setMs2FlagAry(ms2FlagAry)
	execObj.setFileNoTitleAry(fileNoTitleAry)
	execObj.setMs2TolL(ms2TolMainL)
	execObj.setMs2TolR(ms2TolMainR)
	execObj.setMs2TolU(ms2TolU)
	execObj.setMs2KeyType(ms2KeyType)
	execObj.setTseq(ReqFileType::CSV_SEQ)
	execObj.setTpeakList(ReqFileType::CSV_PEAK_LIST_FILE)
	execObj.setTcomm(ReqFileType::CSV_PEAK_COMMENT)
	execObj.setKeyToJpostScore(nil)
#	execObj.setKeyToJpostScore(keyToJpostScore)
	execObj.setMs2PeakSelectBin(ms2PeakSelectBin)
	execObj.setBinRange(binRange)
	execObj.setPlistMzNum(plistMzNum)
	immoResAry = execObj.exec()
	execObj = nil


	# 結果のCsvに出力するタイトルをマージする。
	allTitleAry = DisSRtools.titleMerge(fileNoTitleAry)


	# PeptsURL書き換え用のパラメータを作成する
	peptUrlParam = {}
	if(ms2TolMainL < ms2TolMainR)
		peptUrlParam[PepHitConst::GET_MASS_ERROR] = ms2TolMainR
	else
		peptUrlParam[PepHitConst::GET_MASS_ERROR] = ms2TolMainL
	end
	if(ms2TolU == DisSRconst::DSR_TOL_U_PPM)
		peptUrlParam[PepHitConst::GET_MASS_ERROR_UNIT] = ms2TolU
	else
		peptUrlParam[PepHitConst::GET_MASS_ERROR_UNIT] = DisSRconst::DSR_TOL_U_DA_FULL
	end
	peptUrlParam[PepHitConst::GET_MS2_NUM] = plistMzNum
	if(ms2PeakSelectBin == DisSRconst::DSR_MS2_M_BIN_MZ_Y)
		peptUrlParam[PepHitConst::GET_MS2_BIN_RANGE] = binRange
	end
#p peptUrlParam
#exit(0)

	# b+y:TagLen:x のカラムの出力を停止する 2019-05-30 taba
	maxTagLen = 0


	# 各結果を纏めてCsvDataを作成する
	execObj = ResultToCsvData.new()
	execObj.setAllTitleAry(allTitleAry)
	execObj.setFileNoTitleAry(fileNoTitleAry)
	execObj.setScanNoHit(scanNoHit)
	execObj.setJpostScoreAry(jpostScoreAry)
	execObj.setImmoResAry(immoResAry)
	execObj.setMaxTagLen(maxTagLen)
	execObj.setPeptsURLparam(peptUrlParam)
	execObj.setMs2KeyType(ms2KeyType)
	csvData = execObj.exec()
	execObj = nil
	allTitleAry = nil
	scanNoHit = nil
	jpostScoreAry = nil
	peptUrlParam = nil


	# 結果のCSVファイルを作成
	execObj = ArrayToCsv.new()
	execObj.setDataAry(csvData)
	execObj.setOutFile(outFile)
	execObj.setCsvTitle(csvData.keys())
	execObj.exec()
	execObj = nil
	csvData = nil

print "After:ArrayToCsv:#{Time.now()}\n"


rescue SystemExit
	raise
rescue Exception => aCaller
	puts("*** Error interrupted.  (#{Time.now.to_s}) ***")
	puts()
	raise
end

exit(0)
