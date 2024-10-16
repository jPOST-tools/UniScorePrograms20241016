#
# Copyright (c) 2012 Eisai Co., Ltd. All rights reserved.
#

=begin
-----------------------------------------------------------------------------
	Arrayクラスを拡張して標準偏差を求められるようにする

	作成日 2018-04-19 taba
-----------------------------------------------------------------------------
=end

class Array
	# 要素の合計を算出する
	def sum()
		rtc = inject(0.0){|r,i|
			r += i
		}
		return rtc
	end

	# 要素の平均を算出する
	def avg()
		sumWk = sum()
		return sum / size
	end

	# 要素の偏差２乗和を算出する
	def deviation_sum_of_squares()
		avgWk = avg()
		rtc = inject(0.0){|r,i|
			r += (i - avgWk) ** 2
		}
		return [rtc,avgWk]
	end

	# 要素の分散を算出する
	def variance()
		(devSumSq,avgWk) = deviation_sum_of_squares()
		return [devSumSq / size, avgWk]
	end

	# 要素の標準偏差を算出する
	def standard_deviation()
		(varianceWk,avgWk) = variance()
		stdev = Math.sqrt(varianceWk)
		return [stdev,avgWk]
	end
end

=begin
//------------------------------------------------------------------
	Class MyTools

	どのクラスに属せば良いかが曖昧な自作の関数を登録する

	MyTools.PrintfAndExit()
	エラーが発生したときに時刻とスタックとレースを出力し
	指定された終了ステータスでexitする関数
	
	<期待する使われ方>
	MyTools.PrintfAndExit(
		1,"ClassName-#{self.class()} : MissType.",caller(0))

	作成日2011-04-21 taba
//------------------------------------------------------------------
=end

class MyTools
	def MyTools.printfAndExit(aExitCode,aMessage,*aCallre)
		puts(aMessage)
		if(aCallre.empty? == false)
			puts()
			puts("*** stack trace information (#{Time.now.to_s}) ***")
			aCallre.each { |aStr|
				puts(aStr)
			}
		end
		exit(aExitCode)
	end

	def MyTools.convArrayToHash(aAry)
		rtc = Hash.new()
		aAry.each_index{|pt|
			rtc[pt] = aAry[pt]
		}
		return rtc
	end

	def MyTools.getTimeStr()
		timeWk = Time.now()
		return sprintf("%d/%02d/%02d %02d:%02d:%02d:%06d",
			timeWk.year(),
			timeWk.mon(),
			timeWk.day(),
			timeWk.hour(),
			timeWk.min(),
			timeWk.sec(),
			timeWk.usec())
	end

	def MyTools.uniqueName()
		timeWk = Time.now()
		return sprintf("%d%02d%02d%02d%02d%02d%06d",
			timeWk.year(),
			timeWk.mon(),
			timeWk.day(),
			timeWk.hour(),
			timeWk.min(),
			timeWk.sec(),
			rand(999999))
	end

	def MyTools.statusFileWrite(aFileName,aStr,aPos=nil)
		retryCount = 10
		while(retryCount != 0) do
			begin
				fp = File.open(aFileName,File::RDWR|File::CREAT|File::BINARY)
				retryCount = 0
			rescue Errno::EACCES
				sleep(0.5)
				retryCount -= 1
			end
		end
		fp.flock(File::LOCK_EX)
		if(aPos.nil? == false)
			fp.pos = aPos
		else
			fp.seek(0,File::SEEK_END)
		end
		nowPos = fp.pos
		fp.write(aStr)
		fp.flush()
		fp.flock(File::LOCK_UN)
		fp.close()
		return nowPos
	end

	def MyTools.jobParamToArray(confObj,paraFile)
		if(confObj[Pconst::P_PHP_DIR] == nil)
			MyTools.printfAndExit(1,"confObj[#{Pconst::P_PHP_DIR}] is nill.",caller(0))
		end

		cmdStr = '"' + 
		confObj[Pconst::P_PHP_DIR].gsub("\\","/") +
		"/php\" #{Pconst::P_JOB_PARAM_TO_JSON} \"#{paraFile}\""

		jsonStr = ""
		IO.popen(cmdStr,"r"){|fp|
			jsonStr = fp.read()
		}
		exitCode = ($?.to_i() / 256)
		if(exitCode != 0)
			MyTools.printfAndExit(1,"popen(#{cmdStr}) is false.(exitCode=#{exitCode})",caller(0))
		end 

		rtc = JSON.parse(jsonStr)
		return rtc
	end

	def MyTools.is_windows()
		return Dir.exist?('c:\windows')
	end

	def MyTools.createLinkWindows(latestFolder,outDir)
		if(Dir.exists?(latestFolder) == true)
			cmdstr = "../../bin/linkd #{latestFolder} /D"
			if(system(cmdstr) == false)
#				exitCode = $?
#				MyTools.printfAndExit(1,"#{cmdstr} is false.(exitCode=#{exitCode})",caller(0))
				toName = File.dirname(latestFolder) + '/Backup_' + MyTools.uniqueName()
				File.rename(latestFolder,toName)
			end
		end
		cmdstr = "../../bin/linkd #{latestFolder} #{outDir}"
		if(system(cmdstr) == false)
			exitCode = $?
			MyTools.printfAndExit(1,"#{cmdstr} is false.(exitCode=#{exitCode})",caller(0))
		end
	end

	def MyTools.createLinkLinux(latestFolder,outDir)
		if(FileTest.symlink?(latestFolder) == true)
			File.unlink(latestFolder)
		elsif(Dir.exists?(latestFolder) == true)
			toName = File.dirname(latestFolder) + '/Backup_' + MyTools.uniqueName()
			File.rename(latestFolder,toName)
		end
		File.symlink(outDir,latestFolder)
	end


	def MyTools.splitParamObj(paramObj,myJobObjKey,
		myJobTreeKey,inTypeAry,outTypeAry,tmpTypeAry)

		if(paramObj[Pconst::P_PARAM][myJobObjKey][Pconst::P_PARAM_ITEM].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_PARAM}][#{myJobObjKey}][#{Pconst::P_PARAM_ITEM}] is null.",caller(0))
		end
		paraItem = paramObj[Pconst::P_PARAM][myJobObjKey][Pconst::P_PARAM_ITEM]

		if(paramObj[Pconst::P_IN_FILE][myJobObjKey].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_IN_FILE}][#{myJobObjKey}] is null.",caller(0))
		end

		inFile = Hash.new()
		fileAry = paramObj[Pconst::P_IN_FILE][myJobObjKey]
		inTypeAry.each{|fileType|
			if(fileAry[fileType].nil? == true)
				MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
			end
			if(fileAry[fileType][myJobTreeKey].nil? == true)
				inWkAry = fileAry[fileType][myJobTreeKey.to_s()]
			else
				inWkAry = fileAry[fileType][myJobTreeKey]
			end
			if(inWkAry[0].kind_of?(Array) == false)

				(fileNameWk,noUseFtype) = inWkAry
				inFile[fileType] = fileNameWk
			else
				inFile[fileType] = Array.new()
				inWkAry.each_index{|key|
					(fileNameWk,noUseFtype) = inWkAry[key]
					inFile[fileType][key] = fileNameWk
				}
			end
		}

		if(paramObj[Pconst::P_OUT_FILE][myJobObjKey].nil? == true)
			MyTools.printfAndExit(1,"paramObj[#{Pconst::P_OUT_FILE}][#{myJobObjKey}] is null.",caller(0))
		end
		outFile = Hash.new()
		fileAry = paramObj[Pconst::P_OUT_FILE][myJobObjKey]
		outTypeAry.each{|fileType|
			if(fileAry[fileType].nil? == true)
				MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
			end
			if(fileAry[fileType][myJobTreeKey].nil? == true)
				outWkAry = fileAry[fileType][myJobTreeKey.to_s()]
			else
				outWkAry = fileAry[fileType][myJobTreeKey]
			end
			if(outWkAry[0].kind_of?(Array) == false)

				(fileNameWk,noUseFtype) = outWkAry
				outFile[fileType] = fileNameWk
			else
				outFile[fileType] = Array.new()
				outWkAry.each_index{|key|
					(fileNameWk,noUseFtype) = outWkAry[key]
					outFile[fileType][key] = fileNameWk
				}
			end
		}

		if(paramObj[Pconst::P_TEMP_FILE].length <= 0)
			splitFile = nil
		elsif(paramObj[Pconst::P_TEMP_FILE][myJobObjKey].nil? == true)
			tmpFile = nil
		else
			tmpFile = Hash.new()
			fileAry = paramObj[Pconst::P_TEMP_FILE][myJobObjKey]
			tmpTypeAry.each{|fileType|
				if(fileAry[fileType].nil? == true)
					MyTools.printfAndExit(1,"fileAry[#{fileType}] is null.",caller(0))
				end
				(fileNameWk,noUseFtype) = fileAry[fileType][myJobTreeKey]
				tmpFile[fileType] = fileNameWk
			}
		end

		if(paramObj[Pconst::P_SPLIT_FILE].length <= 0)
			splitFile = nil
		elsif(paramObj[Pconst::P_SPLIT_FILE][myJobObjKey].nil? == true || paramObj[Pconst::P_SPLIT_FILE][myJobObjKey][myJobTreeKey].nil? == true)
			splitFile = nil
		else
			(splitFile,noUseFtype) = paramObj[Pconst::P_SPLIT_FILE][myJobObjKey][myJobTreeKey]
		end
		return [paraItem,inFile,outFile,tmpFile,splitFile]
	end

	def MyTools.inputCheckParaItem(stdParam,paraItem)
		stdParam.each{|wkAry|
			(paraKey,dummy,dummy,dummy,dummy,inCheck,dummy,dummy) = wkAry
			if(inCheck != Pconst::IN_CHK_REQUIRED)
				next
			end
			if(paraItem[paraKey].nil? == true)
				MyTools.printfAndExit(1,"paraItem[#{paraKey}] is null.",caller(0))
			end
		}
	end

	def MyTools.createNoExistsDir(dirName)
		sepStr = "/"
		dirAry = dirName.split(sepStr)
		dirWk = ""
		dirAry.each{|val|
			dirWk += val
			if(dirWk == '' || dirWk == '/' || dirWk == '//' || dirWk.match(/^[a-zA-Z]:$/) != nil || dirWk.match(/[a-zA-Z]:\/$/) != nil || dirWk.match(/\/\/[^\/]+$/) != nil)
				dirWk += sepStr
				next
			end
			if(File.exist?(dirWk) == false)
				if(Dir.mkdir(dirWk) == false)
					MyTools.printfAndExit(1,"Dir.mkdir(#{dirWk}) is false.",caller(0))
				end
			else
				if(Dir.exist?(dirWk) == false)
					MyTools.printfAndExit(1,"Dir already exitsts.(dir=#{dirWk})",caller(0))
				end
			end
			dirWk += sepStr
		}
	end

	def MyTools.is_numeric(numStr)
		begin
			wkNum = Integer(numStr)
			return true
		rescue
			return false
		end
	end

	def MyTools.getJobObjParam(progDir,verFile,paraFile,progKind,confObj)
		if(progKind == Pconst::P_RUBY_DIR)
			cgiStr = confObj[Pconst::P_RUBY_DIR] + '/ruby '
			progStr = Pconst::P_JOB_PARAM_TO_JSON_R
			varFileWk = "#{progDir}/" + sprintf(verFile,'rb')
			paraFileWk = sprintf(paraFile,'rb')
		elsif(progKind == Pconst::P_PHP_DIR)
			cgiStr = confObj[Pconst::P_PHP_DIR] + '/php '
			progStr = Pconst::P_JOB_PARAM_TO_JSON
			varFileWk = "#{progDir}/" + sprintf(verFile,'php')
			paraFileWk = sprintf(paraFile,'php')
		else
			MyTools.printfAndExit(1,"ProgKind is mistake.(#{progKind})",caller(0))
		end
		if(MyTools.is_windows() == true)
			cgiStr = cgiStr.gsub("/","\\")
		else
			cgiStr = cgiStr.gsub("\\","/")
		end
		cmdStr = "#{cgiStr} #{progStr} #{varFileWk} #{paraFileWk}"
		rtc = `#{cmdStr}`
		if($? != 0)
			p cmdStr
			p rtc
			MyTools.printfAndExit(1,"cmdExec is false.(#{$?})",caller(0))
		end
		return JSON.parse(rtc)
	end

	def MyTools.getLancherParam(lanchParamAry,findKey)
		lanchParamAry.each{|aItemAry|
			(nowKey,lanchItemAry) = aItemAry
			if(nowKey == findKey)
				return lanchItemAry
			end
		}
		MyTools.printfAndExit(1,"findKey is not found.(#{findKey})",caller(0))
	end

	def MyTools.getPHPcmd()
		# JobRequestConf.jsonの読み出し
		jsonStr = File.read(Pconst::P_JOBREQ_CONF_FILE)

		confObj = JSON.parse(jsonStr)
		jsonStr = nil
		if(confObj[Pconst::P_PHP_DIR].nil? == true)
			MyTools.printfAndExit(1,"confObj[#{Pconst::P_PHP_DIR}] is nill.",caller(0))
		end
		rtc = confObj[Pconst::P_PHP_DIR] + "\\php"
		return rtc
	end

	def MyTools.getPHPvalue(aCmdName,aOption)
		phpCmd = MyTools.getPHPcmd()
		cmdStr = "#{phpCmd} #{aCmdName}"
		if(aOption.nil? == false)
			cmdStr += " #{aOption}"
		end
		jsonStr = `#{cmdStr}`
		exitCode = $?
		if(exitCode != 0)
			p cmdStr
			p jsonStr
			MyTools.printfAndExit(1,"(#{cmdStr}) is false.(#{exitCode})",caller(0))
		end
		return JSON.parse(jsonStr)
	end

	def MyTools.getInParam(aJobName,aArgv,aInFileKey,aOutFileKey,aTmpFileKey)

		# 入力パラメータの取り出し
		myJobObjKey = aArgv[0]
		myJobGrp = aArgv[1]
		myJobTreeKey = aArgv[2]
		paramFile = aArgv[3]

		# JobRequestConf.jsonの読み出し
		jsonStr = File.read(Pconst::P_JOBREQ_CONF_FILE)
		confObj = JSON.parse(jsonStr)
		jsonStr = nil

		# JobParam.phpの読み出し
		paramObj = MyTools.jobParamToArray(confObj,paramFile)

		(paraItem,inFile,outFile,tmpFile,splitFile) = 
			MyTools.splitParamObj(
				paramObj,myJobObjKey,myJobTreeKey.to_i(),
				aInFileKey,
				aOutFileKey,
				aTmpFileKey
			)
		paramObj = nil

		# パラメータの未入力チェック
		stdParam = MyParamData.getParamData()
		MyTools.inputCheckParaItem(stdParam[Pconst::P_PARAM][aJobName][Pconst::P_PARAM_ITEM],paraItem)
		stdParam = nil

		return [paraItem,inFile,outFile,tmpFile,splitFile]
	end

	def MyTools.ary_ratio(aBunsiAry,aBunboAry)
		rtc = []
		rtcLog = []

		aBunsiAry.each_index{|i|
			bunsiVal = aBunsiAry[i].to_f()
			bunboVal = aBunboAry[i].to_f()
			ratioWk = bunsiVal / bunboVal
			rtc.push(ratioWk.round(2))
			rtcLog.push(Math.log(ratioWk))
		}
#p rtc,rtcLog
#exit(0)
		return [rtc,rtcLog]
	end

	def MyTools.ary_filterLowVal(aBunboAry,aBunsiAry,aFilterVal)
		rtcBunbo = []
		rtcBunsi = []
		aBunboAry.each_index{|i|
			bunboVal = aBunboAry[i]
			bunsiVal = aBunsiAry[i]
			if(bunboVal <= aFilterVal)
				next
			end
			if(bunsiVal <= aFilterVal)
				next
			end
			rtcBunbo.push(bunboVal)
			rtcBunsi.push(bunsiVal)
		}
		return [rtcBunbo,rtcBunsi]
	end

	def MyTools.ary_filter(
		aRatioLogE,aStdDevLow,aStdDevHeigh,aBunboAry,aBunsiAry)

		rtcBunbo = []
		rtcBunsi = []

		if(aRatioLogE.length != aBunboAry.length)
			p aRatioLogE,aBunboAry
			MyTools.printfAndExit(1,"aRatioLogE is mistake.",caller(0))
		end
		if(aRatioLogE.length != aBunsiAry.length)
			p aRatioLogE,aBunsiAry
			MyTools.printfAndExit(1,"aRatioLogE is mistake.",caller(0))
		end

		aRatioLogE.each_index{|i|
			ratioLogEwk = aRatioLogE[i]
			bunboVal = aBunboAry[i]
			bunsiVal = aBunsiAry[i]
			if(ratioLogEwk < aStdDevLow)
				next
			end
			if(ratioLogEwk > aStdDevHeigh)
				next
			end
			rtcBunbo.push(bunboVal)
			rtcBunsi.push(bunsiVal)
		}
		return [rtcBunbo,rtcBunsi]
	end

	def MyTools.setCsvDataItem(aSetValAry,aLineNo,aCsvData)
		aSetValAry.each{|aItemAry|
			(aTitle,aVal) = aItemAry
			if(aCsvData[aTitle] == nil)
				aCsvData[aTitle] = []
			end
			aCsvData[aTitle][aLineNo] = aVal
		}
	end

end

=begin
//------------------------------------------------------------------
	class JsonDBtools

	JsonDB関係のいろんなツールを登録するクラス。

	作成日 2011-07-25 taba
//------------------------------------------------------------------
=end

class JsonDBtools

# FastaDBのフィールド定義
	F_ANNOTATION = 0
	F_PROT_SEQ = 1
	F_UNIPROT_KEY = 2
	F_DB_KEY_FULL = 3

# GeneDBのフィールド定義
	F_GENE_INFO = 0
	F_GENE_GO = 1

# Gene-GOのフィールド定義
	F_GO_FUNC = 0
	F_GO_COMP = 1
	F_GO_PROC = 2

# Gene-Infoのフィールド定義
	F_SYMBOL = 0
	F_LOCUS_TAG = 1
	F_SYNONYMS = 2
	F_DB_X_REFS = 3
	F_CHROMOSOME = 4
	F_MAP_LOCATION = 5
	F_DESCRIPTION = 6
	F_TYPE_OF_GENE = 7
#	F_SYMBOL_FROM_NOM = 8
#	F_FULL_NAME_NOM = 9
#	F_NORMENCLATURE_STS = 10
#	F_OTHER_DESIGNA = 11

	def JsonDBtools.getFastaKey(aKeyStr)
		keyAry = aKeyStr.split('|')
		keyCode = keyAry[0];
		keyNum = keyAry.length
		if(keyCode == 'gi')
			if(keyNum >= 2)
				return keyAry[1]
			end
		elsif(keyCode == 'tr')
			if(keyNum >= 2)
				return keyAry[1]
			end
		elsif(keyCode == 'sp')
#			if(keyNum >= 2)
#				return keyAry[1]
#			end
			if(keyNum >= 3)
				return keyAry[2]
			end
		else
			return keyCode
		end
		p aKeyStr
		MyTools.printfAndExit(1,"keyStr is mistake.",caller(0))
	end

	def JsonDBtools.getGeneDBkey(aKeyStr)
		keyAry = aKeyStr.split('|')
		keyCode = keyAry[0];
		keyNum = keyAry.length
		if(keyCode == 'gi')
			if(keyNum >= 2)
				return keyAry[1]
			end
		elsif($keyCode == 'tr')
			if(keyNum >= 3)
				return keyAry[2]
			end
		elsif(keyCode == 'sp')
			if(keyNum >= 3)
				return keyAry[2]
			end
		else
			return keyCode;
		end
		p aKeyStr
		MyTools.printfAndExit(1,"keyStr is mistake.",caller(0))
	end

	def JsonDBtools.getFastaKeyToDBkey(aKeyStr)
		wkAry = aKeyStr.split(':',2)
		if(wkAry.length == 2)
			dbKey = wkAry[1]
		else
			dbKey = wkAry[0]
		end
		return File.basename(dbKey,'.*')
	end
end

=begin
//------------------------------------------------------------------
	Class MsFileReader

	サーモ社のRawDataを読み出すクラス

	作成日2012-07-20 taba
//------------------------------------------------------------------
=end

class MsFileReader
	TYPE_MASS_CONTROLLER = 0

	def initialize(aLogFile='')
		@readObj = WIN32OLE.new("MSFileReader.Xrawfile.1")
		if(aLogFile != '')
			@logObj = Logger.new(aLogFile)
		end
	end

	def logWrite(aMsg)
		if(@logObj.nil? == true)
			return
		end
		@logObj.info(aMsg)
	end

	def open(aRawFile)
		if(File.file?(aRawFile) == false)
			p aRawFile
			MyTools.printfAndExit(1,"aRawFile is not found.",caller(0))
		end
		self.logWrite("start:open(#{aRawFile})")
		@readObj.open(aRawFile)
		self.logWrite("end:open()")
	end

	def close()
		self.logWrite("start:close()")
		@readObj.close()
		self.logWrite("end:close()")
		@readObj = nil
	end

	def getNumberOfControllersOfType(massContType)
		massContNo = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:getNumberOfControllersOfType(#{massContType})")
		@readObj.GetNumberOfControllersOfType(massContType,massContNo)
		self.logWrite("end:getNumberOfControllersOfType()")
		return massContNo.value
	end

	def setCurrentController(massContType,massContNo)
		self.logWrite("start:setCurrentController(#{massContType},#{massContNo})")
		@readObj.SetCurrentController(massContType,massContNo)
		self.logWrite("end:setCurrentController()")
	end


	def rtFromScanNum(aScanNo)
		rtime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:RTFromScanNum(#{aScanNo})")
		@readObj.RTFromScanNum(aScanNo,rtime)
		self.logWrite("end:RTFromScanNum()")

		if(rtime.value <= 0)
			p aScanNo,rtime.value
			MyTools.printfAndExit(1,"rtime is mistake.",caller(0))
		end

		return rtime.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum()")
		return rtc.value
	end

	def getPrecursorMassForScanNum(aScanNo)
		msOrder = self.getMSOrderForScanNum(aScanNo)

		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetPrecursorMassForScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetPrecursorMassForScanNum(aScanNo,msOrder,rtc)
		self.logWrite("end:GetPrecursorMassForScanNum()")
		return rtc.value
	end

	def getPrecursorInfoFromScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pvarPrecursorInfos = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pnArraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)

		self.logWrite("start:GetPrecursorInfoFromScanNum(#{aScanNo})")
		@readObj.GetPrecursorInfoFromScanNum(aScanNo,pvarPrecursorInfos,pnArraySize)
		self.logWrite("end:GetPrecursorInfoFromScanNum()")
		return pvarPrecursorInfos.value
	end

	def findPrecursorMassInFullScan(aScanNo)
		pnMasterScan = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		pdFoundMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdHeaderMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pnChargeState = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:FindPrecursorMassInFullScan(#{aScanNo})")
		@readObj.FindPrecursorMassInFullScan(aScanNo,pnMasterScan,pdFoundMass,pdHeaderMass,pnChargeState)
		self.logWrite("end:FindPrecursorMassInFullScan()")
		return [pnMasterScan.value,pdFoundMass.value,pdHeaderMass.value,pnChargeState.value]
	end

	def getFullMSOrderPrecursorDataFromScanNum(aScanNo)
		msOrder = 1

		pvarFullMSOrderPrecursorInfo = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFullMSOrderPrecursorDataFromScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetFullMSOrderPrecursorDataFromScanNum(aScanNo,msOrder,pvarFullMSOrderPrecursorInfo)
		self.logWrite("end:GetFullMSOrderPrecursorDataFromScanNum()")
		return pvarFullMSOrderPrecursorInfo.value
	end

	def getPrecursorRangeForScanNum(aScanNo)
		msOrder = self.getMSOrderForScanNum(aScanNo)

		pdFirstPrecursorMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdLastPrecursorMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pbIsValid = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetPrecursorRangeForScanNum(#{aScanNo},#{msOrder})")
		@readObj.GetPrecursorRangeForScanNum(aScanNo,msOrder,pdFirstPrecursorMass,pdLastPrecursorMass,pbIsValid)
		self.logWrite("end:GetPrecursorRangeForScanNum()")
		return [pdFirstPrecursorMass.value,pdLastPrecursorMass.value]
	end

	def getChroData(
		nChroType1,nChroOperator,nChroType2,
		szFilter,szMassRanges1,szMassRanges2,
		dDelay,pdStartTime,pdEndTime,
		nSmoothingType,nSmoothingValue)

		szFilterRef = WIN32OLE_VARIANT.new(szFilter,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		szMassRanges1Ref = WIN32OLE_VARIANT.new(szMassRanges1,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		szMassRanges2Ref = WIN32OLE_VARIANT.new(szMassRanges2,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		pdStartTimeRef = WIN32OLE_VARIANT.new(pdStartTime,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pdEndTimeRef = WIN32OLE_VARIANT.new(pdEndTime,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		pvarChroData = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pvarPeakFlags = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		pnArraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)

		self.logWrite("start:GetChroData(#{szMassRanges1})")

		@readObj.GetChroData(
			nChroType1,nChroOperator,nChroType2,
			szFilterRef,szMassRanges1Ref,szMassRanges2Ref,
			dDelay,pdStartTimeRef,pdEndTimeRef,
			nSmoothingType,nSmoothingValue,
			pvarChroData,pvarPeakFlags,pnArraySize
		)

		self.logWrite("end:GetChroData(#{szMassRanges1})")
		return [pvarChroData.value,pvarPeakFlags.value]
	end

	def scanNumFromRT(aRtime)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:ScanNumFromRT(#{aRtime})")
		@readObj.ScanNumFromRT(aRtime,rtc)
		self.logWrite("end:ScanNumFromRT(#{aRtime})")
		return rtc.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum(#{aScanNo})")
		return rtc.value
	end

	def getInstModel()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetInstModel()")
		@readObj.GetInstModel(rtc)
		self.logWrite("end:GetInstModel()")
		return rtc.value
	end

	def getFirstSpectrumNumber()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFirstSpectrumNumber()")
		@readObj.GetFirstSpectrumNumber(rtc)
		self.logWrite("end:GetFirstSpectrumNumber()")
		return rtc.value
	end

	def getLastSpectrumNumber()
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetLastSpectrumNumber()")
		@readObj.GetLastSpectrumNumber(rtc)
		self.logWrite("end:GetLastSpectrumNumber()")
		return rtc.value
	end

	def getMSOrderForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMSOrderForScanNum(#{aScanNo})")
		@readObj.GetMSOrderForScanNum(aScanNo,rtc)
		self.logWrite("end:GetMSOrderForScanNum(#{aScanNo})")
		return rtc.value
	end

	def isCentroidScanForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:IsCentroidScanForScanNum(#{aScanNo})")
		@readObj.IsCentroidScanForScanNum(aScanNo,rtc)
		self.logWrite("end:IsCentroidScanForScanNum(#{aScanNo})")
		return rtc.value
	end

	def isProfileScanForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:IsProfileScanForScanNum(#{aScanNo})")
		@readObj.IsProfileScanForScanNum(aScanNo,rtc)
		self.logWrite("end:IsProfileScanForScanNum(#{aScanNo})")
		return rtc.value
	end

	def getScanHeaderInfoForScanNum(aScanNo)
		numPackets = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		startTime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		lowMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		highMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		tic = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		bpMass = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		bpInt = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		channelNum = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		uniformTime = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		frequency = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetScanHeaderInfoForScanNum(#{aScanNo})")
		@readObj.GetScanHeaderInfoForScanNum(
			aScanNo,
			numPackets,
			startTime,
			lowMass,
			highMass,
			tic,
			bpMass,
			bpInt,
			channelNum,
			uniformTime,
			frequency

		)
		self.logWrite("end:GetScanHeaderInfoForScanNum(#{aScanNo})")
		return [numPackets.value,startTime.value,lowMass.value,highMass.value,tic.value,bpMass.value,bpInt.value,channelNum.value,uniformTime.value,frequency.value]
	end

	def getFilterForScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetFilterForScanNum(#{aScanNo})")
		@readObj.GetFilterForScanNum(aScanNo,rtc)
		self.logWrite("end:GetFilterForScanNum(#{aScanNo})")
		return rtc.value
	end

	def rtFromScanNum(aScanNo)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:RTFromScanNum(#{aScanNo})")
		@readObj.RTFromScanNum(aScanNo,rtc)
		self.logWrite("end:RTFromScanNum(#{aScanNo})")
		return rtc.value
	end

	def getMassListFromScanNum(aScanNo)
		filter = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_BSTR|WIN32OLE::VARIANT::VT_BYREF)
		peakWidth = WIN32OLE_VARIANT.new(0.0,WIN32OLE::VARIANT::VT_R8|WIN32OLE::VARIANT::VT_BYREF)
		ptObj = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		peaksFlags = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_VARIANT|WIN32OLE::VARIANT::VT_BYREF)
		arraySize = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetMassListFromScanNum(#{aScanNo})")
		@readObj.GetMassListFromScanNum(
			aScanNo,
			filter,
			0,
			0,
			0,
			0,
			peakWidth,
			ptObj,
			peaksFlags,
			arraySize
		)
		self.logWrite("end:GetMassListFromScanNum(#{aScanNo})")
		return [filter.value,peakWidth.value,ptObj.value,peaksFlags.value,arraySize.value]
	end

	def getActivationTypeForScanNum(aScanNo,aMSOrder)
		rtc = WIN32OLE_VARIANT.new(nil,WIN32OLE::VARIANT::VT_I4|WIN32OLE::VARIANT::VT_BYREF)
		self.logWrite("start:GetActivationTypeForScanNum(#{aScanNo})")
		@readObj.GetActivationTypeForScanNum(aScanNo,aMSOrder,rtc)
		self.logWrite("end:GetActivationTypeForScanNum(#{aScanNo})")
		return rtc.value
	end

end

=begin
//------------------------------------------------------------------
	Class CsvFileToArray

	CSVファイルの内容をタイトル文字列をキーにした
	Arrayに変換する。

	作成日2012-08-03 taba
//------------------------------------------------------------------
=end

class CsvFileToArray
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setUseTitle(aVal)
		@useTitle = aVal
	end

	def getTitleAry()
		if(@titleAry.nil? == true)
			MyTools.printfAndExit(1,"@titleAry is null.",caller(0))
		end
		return @titleAry
	end

	def getDataAry()
		if(@dataAry.nil? == true)
			MyTools.printfAndExit(1,"@dataAry is null.",caller(0))
		end
		return @dataAry
	end

	def creUseTitle(aRaw,aUseTitle)
		rtc = Array.new()
		aRaw.each_index{|i|
			if(aUseTitle.nil? == false)
				if(aUseTitle.find_index(aRaw[i]) == nil)
					next
				end
			end
			rtc[i] = aRaw[i]
		}
		return rtc
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		lineNo = 0
		dataWk = Hash.new()
		titleWk = nil

		CSV.foreach(@inFile,{:col_sep => "\t", :encoding => "UTF-8"}){|aRaw|
			lineNo += 1
			if(lineNo == 1)
				titleWk = self.creUseTitle(aRaw,@useTitle)
				titleWk.each{|aVal|
					if(aVal.nil? == true)
						next
					end
					dataWk[aVal] = Array.new()
				}
				next
			end
			setLineNo = lineNo - 2
			aRaw.each_index{|i|
				if(titleWk[i].nil? == true)
					next
				end
				dataWk[titleWk[i]][setLineNo] = aRaw[i]
			}

		}
		@titleAry = titleWk.compact()
		@dataAry = dataWk
	end
end

=begin
//------------------------------------------------------------------
	Class ArrayToCsv

	入力のArrayとCsvTitleのArrayからCsvTitilの順番で
	Csvファイルを作成する。

	作成日2012-08-03 taba
//------------------------------------------------------------------
=end

class ArrayToCsv
	def initialize()
	end

	def setDataAry(aVal)
		@dataAry = aVal
	end

	def setOutFile(aVal)
		@outFile = aVal
	end

	def setCsvTitle(aVal)
		@csvTitle = aVal
	end

	def check()
		if(@dataAry.nil? == true)
			MyTools.printfAndExit(1,"@dataAry is nill.",caller(0))
		end
		if(@outFile.nil? == true)
			MyTools.printfAndExit(1,"@outFile is nill.",caller(0))
		end
		if(@csvTitle.nil? == true)
			MyTools.printfAndExit(1,"@csvTitle is nill.",caller(0))
		end
	end

	def exec()
		self.check()

		sepStr = "\t"
		newLine = "\n"

# 2014-09-17 既に作成されているファイルの場合上書きしてしまう。
# サイズが縮小した時に、前のファイルの残骸が残るので、
# 存在時は、新規作成するようにする。
#		fp = File.open(@outFile,File::RDWR|File::CREAT|File::BINARY)

		fp = File.open(@outFile,'w+b')

		lineStr = ''
		@csvTitle.each{|aVal|
			if(lineStr != '')
				lineStr += sepStr
			end
			lineStr += aVal
		}
		lineStr += newLine
		fp.write(lineStr)

		titleNum = @csvTitle.length()
		dataNum = @dataAry[@csvTitle[0]].length()
		for i in 0...dataNum
			lineStr = ''
			for j in 0...titleNum
#				if(lineStr != '') 2013-11-12 taba
				if(j != 0)
					lineStr += sepStr
				end
				titleKey = @csvTitle[j]
				if(@dataAry[titleKey][i].nil? == true)
					next
				end
				lineStr += '"' + @dataAry[titleKey][i].to_s() + '"'
			end
			lineStr += newLine
			fp.write(lineStr)
			lineStr = nil
		end
		fp.close()
	end
end

=begin
-----------------------------------------------------------------------------
	RawFileControl

	Thermo社のRawFileのアクセスファイル記述子を管理するクラス。

	作成日 2013-11-14 taba
-----------------------------------------------------------------------------
=end

class RawFileControl
	def initialize()
		@rawObj = Hash.new()
	end

	def initRawObj(aRawFile,aReaderLog)
		if(aReaderLog == '')
			readObj = MsFileReader.new()
		else
			MyTools.createNoExistsDir(File.dirname(aReaderLog))
			readObj = MsFileReader.new(aReaderLog)
		end
		readObj.open(aRawFile)
		massContNo = readObj.getNumberOfControllersOfType(MsFileReader::TYPE_MASS_CONTROLLER)
		readObj.setCurrentController(MsFileReader::TYPE_MASS_CONTROLLER,massContNo)
		return readObj
	end

	def getRawObj(aRawFile,aReaderLog)
		if(@rawObj[aRawFile] == nil)
			@rawObj[aRawFile] = self.initRawObj(aRawFile,aReaderLog)
		end
		return @rawObj[aRawFile]
	end

	def close()
		@rawObj.each{|aKey,aVal|
			aVal.close()
		}
	end
end

=begin
-----------------------------------------------------------------------------
	FastaDB

	FastaFileの内容をDB化するクラス。

	作成日 2018-03-08 taba
-----------------------------------------------------------------------------
=end

class FastaDB
	def initialize()
		@dbObj = {}
	end

	def getFastaDBfile(aFastaFile)
		dbFile = "../../../ConfFiles/userFasta/FastaFiles/#{aFastaFile}"
		if(File.file?(dbFile) == false)
			p dbFile
			MyTools.printfAndExit(1,"dbFile is nill.",caller(0))
		end
		return dbFile
	end

	def getShortKeyStr(aKeyStr)
		wkAry = aKeyStr.split('|')
		return wkAry[wkAry.length - 1]
	end

	def setItem(aHederStr,aSeqStr)
		(longKey,otherStr) = aHederStr.split(' ',2)
		longKey.slice!(0)
		shortKey = self.getShortKeyStr(longKey)
#p longKey,otherStr,shortKey,aSeqStr
#exit(0)
		if(@dbObj[longKey] != nil)
			p longKey
			MyTools.printfAndExit(1,"longKey is duplicate.",caller(0))
		end
		@dbObj[longKey] = [shortKey,otherStr,aSeqStr]
#p @dbObj
#exit(0)
	end

	def getProtKeyToItem(aLongKey)
		if(@dbObj[aLongKey] == nil)
			return nil
		end
		return @dbObj[aLongKey]
	end

	def getBeforeAfterSeq(aItemAry,aSeqStr)
		(shortKey,otherStr,protSeqStr) = aItemAry
		beforeSeq = nil
		afterSeq = nil
		protSeqWk = protSeqStr
		while true do
			topPt = protSeqWk.index(aSeqStr)
			if(topPt == nil)
				break
			end
			if(topPt > 0)
				beforeSeq = protSeqWk[topPt-1]
			else
				beforeSeq = '['
			end
			lastPt = topPt + aSeqStr.length
			if(lastPt >= protSeqWk.length)
				afterSeq = ']'
			else
				afterSeq = protSeqWk[lastPt]
			end
			if(topPt == 1 && beforeSeq == 'M')
				break
			end
			if(beforeSeq == 'K' || beforeSeq == 'R')
				break
			end
			topPt += 1
			protSeqWk = protSeqWk[topPt,protSeqWk.length - topPt]
		end
		if(beforeSeq == nil)
			p aSeqStr,otherStr,aProtSeq
			MyTools.printfAndExit(1,"seqStr is mistake.",caller(0))
		end
		return [beforeSeq,afterSeq]
	end

	def createDBobj(aFastaFile)

		rfp = File.open(aFastaFile,File::RDONLY)

		lineNo = 0
		seqAry = []
		hederStr = nil

		while lineStr = rfp.gets()
			lineNo += 1
			lineStr = lineStr.rstrip()

			if(lineStr[0] == '>')
				if(seqAry.length > 0)
					self.setItem(hederStr,seqAry.join())
				end
				seqAry = []
				hederStr = lineStr
				next
			end
			seqAry.push(lineStr)
		end

		rfp.close()

		if(seqAry.length > 0)
			self.setItem(hederStr,seqAry.join())
		end
#p @dbObj
#exit(0)
	end
end
