# encoding: utf-8
#
# Copyright (c) 2017 Department of Molecular and Cellular Bioanalysis,
# Graduate School of Pharmaceutical Sciences,
# Kyoto University. All rights reserved.
#

=begin
-----------------------------------------------------------------------------
	DisSRtools

	DistinctSearchResultで使用する関数群を定義する。

	作成日 2017-05-18 taba
-----------------------------------------------------------------------------
=end

class DisSRtools
	def DisSRtools.chekcHashKey(aHashData,aAry)
		aAry.each{|aKey|
			if(aHashData[aKey] == nil)
				p aKey
				MyTools.printfAndExit(1,"aHashData[#{aKey}] is nil.",caller(0))
			end
		}
	end

	def DisSRtools.convValHash(aAry)
		rtc = {}
		aAry.each_index{|i|
			rtc[aAry[i]] = i
		}
		return rtc
	end

	def DisSRtools.getScanNo(aTitleStr)
		wkAry = aTitleStr.split(',',2)
		if(wkAry.length < 2)
			return aTitleStr
#			p aTitleStr
#			MyTools.printfAndExit(1,"CometStr is mistake.",caller(0))
		end
		wkAry = wkAry[0].split(' ',2)
		if(wkAry.length < 2)
			p aTitleStr
			MyTools.printfAndExit(1,"CometStr is mistake.",caller(0))
		end
		return wkAry[1]
	end

	def DisSRtools.getPlistStr(aPlistStr)
		fileName = File.basename(aPlistStr)
		wkAry = fileName.split('.')
		if(wkAry.length < 3)
			return "NoKind"
#			p aPlistStr
#			MyTools.printfAndExit(1,"plistStr is mistake.",caller(0))
		end
		return wkAry[wkAry.length - 2]
	end

	def DisSRtools.getAllItem(aTitleAry,aCsvData,aNo)
		rtc = []
		aTitleAry.each{|aTitleWk|
			rtc.push(aCsvData[aTitleWk][aNo])
		}
		return rtc
	end

	def DisSRtools.getItemData(aTitleNoAry,aTitleStr,aAllItemAry)
		pointNum = aTitleNoAry[aTitleStr]
		return aAllItemAry[pointNum]
	end

	def DisSRtools.crePlistComHash(
		aScanNoHit,aFileNoTitleAry,aPlistTitle,aComTitle,aMs2KeyType)

		rtc = {}
		aScanNoHit.each{|aKey,aWkAry|
			(scanNoWk,noUse,inFileNo,noUse,noUse,noUse,allItemAry,noUse,noUse) = aWkAry
			titleNoAry = aFileNoTitleAry[inFileNo]
			plistFile = DisSRtools.getItemData(titleNoAry,aPlistTitle,allItemAry)
			comStr = DisSRtools.getItemData(titleNoAry,aComTitle,allItemAry)
#p plistFile,comStr
#exit(0)
			if(rtc[plistFile] == nil)
				rtc[plistFile] = {}
			end
			if(aMs2KeyType == DisSRconst::DSR_MS2_KEY_TITLE)
				rtc[plistFile][comStr] = true
			else
				rtc[plistFile][scanNoWk] = true
			end
#p rtc
#exit(0)

		}
		return rtc
	end

	def DisSRtools.getFromToAry(aMin,aMax)
		rtc = []
		for i in aMin..aMax do
			rtc.push(i)
		end
		return rtc
	end

	def DisSRtools.getDiffPpm(aSampleDa,aValDa)
		return aValDa * 1000000 / aSampleDa
	end

	def DisSRtools.getSeriesAminoNum(aMatchFlagAryMerge,aChkLen,aSeqWk)

		rtcHit = []
		rtcNoHit = []
		seqLen = aSeqWk.length

		aMatchFlagAryMerge.each{|aIonKind,aMatchFlagPt|

			hitNum = 0
			noHitNum = 0

			1.upto(aChkLen){|i|
				if(aMatchFlagPt[i] == nil)
					noHitNum += 1
					if(hitNum > 0)
						rtcHit.push(hitNum)
					end
					hitNum = 0
				else
					hitNum += 1
					if(noHitNum > 0)
						rtcNoHit.push(noHitNum)
					end
					noHitNum = 0
				end
			}
			if(hitNum > 0)
				rtcHit.push(hitNum)
			end
			if(noHitNum > 0)
				rtcNoHit.push(noHitNum)
			end
		}
		return [rtcHit,rtcNoHit]
	end

	def DisSRtools.getJpostScoreV2(
		bothMatchWk,singleMatchWk,bothUnMatchWk,
		aAllTagHitWk,aAllTagNoHitWk,aMatchFlagIntNo,
		aSeqLen,aUniScCstAry)

		rtc = 0

		(bothMatchConst,singleMatchConst,bothUnMatchConst,tagHitConst,noTagHitConst) = aUniScCstAry

#p bothMatchConst,singleMatchConst,bothUnMatchConst,tagHitConst,noTagHitConst
#exit(0)

#nowBest	bothMatchConst = 2
##		bothMatchConst = 0.4
##		bothMatchConst = 0.42
#		bothMatchConst = 0.8
##		bothMatchConst = 0.9
#		bothMatchConst = 1.2

#nowBest	singleMatchConst = 1
#		singleMatchConst = 0.1
##		singleMatchConst = 0.2
##		singleMatchConst = 0.4
#		singleMatchConst = 0.8

#nowBest	bothUnMatchConst = 0
#		bothUnMatchConst = 0.0
#		bothUnMatchConst = -0.1

#nowBest	tagHitConst = 1
#		tagHitConst = 0.02
#		tagHitConst = 0.03
#		tagHitConst = 0.07
##		tagHitConst = 0.07 / 2

#nowBest	noTagHitConst = 0
#		noTagHitConst = 0.0
#		noTagHitConst = -0.001

#nowNoUse	intNoMagniConst = 0.00002

		rtcBothMatchSum = 0
		rtcSingleMatchSum = 0
		rtcBothUnMatchSum = 0
		rtcTagHitSum = 0
		rtcNoTagHitSum = 0

		bothMatchWk.each{|aHitNum|
			rtcBothMatchSum += aHitNum
			rtc += (bothMatchConst * aHitNum)
		}
#p bothMatchWk,rtc

		singleMatchWk.each{|aHitNum|
			rtcSingleMatchSum += aHitNum
			rtc += (singleMatchConst * aHitNum)
		}
#p singleMatchWk,rtc

		bothUnMatchWk.each{|aHitNum|
			rtcBothUnMatchSum += aHitNum
			rtc += (bothUnMatchConst * aHitNum)
		}
#p bothUnMatchWk,rtc

		aAllTagHitWk.each{|aHitNum|
			rtcTagHitSum += aHitNum
#			rtc += Array(1..aHitNum).sum() * tagHitConst
#			rtc += aHitNum ** 2 * tagHitConst
			rtc += aHitNum * tagHitConst
		}
#p aAllTagHitWk,rtc

		aAllTagNoHitWk.each{|aHitNum|
			rtcNoTagHitSum += aHitNum
#			rtc += Array(1..aHitNum).sum() * noTagHitConst
#			rtc += aHitNum ** 2 * noTagHitConst
			rtc += aHitNum * noTagHitConst
		}
#p aAllTagNoHitWk,rtc

=begin
#p aMatchFlagIntNo
		intNoMagniVal = 1
		aMatchFlagIntNo.each{|aIntNo|
			intNoMagniWk = 1 - intNoMagniConst * (aIntNo - 1)
			intNoMagniVal *= intNoMagniWk
		}
		rtc *= intNoMagniVal

#=begin
		seqLenMagniVal = 1.0 - 1.0 / aSeqLen
		rtc *= seqLenMagniVal
#p aSeqLen,seqLenMagniVal
=end


# 整数になったのでroundをやめる。
#		rtc = rtc.round(1)
#		rtc = rtc.round(2)
##		rtc = rtc.round(3)


#p "a1"
#p rtc
#exit(0)
		return [rtc,rtcBothMatchSum,rtcSingleMatchSum,rtcBothUnMatchSum,rtcTagHitSum,rtcNoTagHitSum]
	end


	def DisSRtools.getPartSeq(aHitTagSeqAry,aTagSeqAry,aConvStrFrom,aConvStrTo)
		rtc = []
		savePartSeq = {}
		aHitTagSeqAry.each{|aSeqStr|
			convSeqStr = aSeqStr.gsub(aConvStrFrom,aConvStrTo)
			if(aSeqStr.length < 2)
				next
			end

			if(savePartSeq[aSeqStr] != nil)
				next
			end
			savePartSeq[aSeqStr] = true

			if(aTagSeqAry[convSeqStr] != nil)
				seqCount = aTagSeqAry[convSeqStr]
			else
				seqCount = 0
			end
			rtc.push("#{aSeqStr}:#{seqCount}")
		}
		return rtc.join(',')
	end

	def DisSRtools.getKeyValStr(aHashAry)
		rtc = []
		aHashAry.each{|aKey,aVal|
			rtc.push("#{aKey}@#{aVal}")
		}
		return rtc.join(',')
	end

	def DisSRtools.getAryPointToAry(aInAry,aPt)
		rtc = []
		aInAry.each{|aItemAry|
			rtc.push(aItemAry[aPt])
		}
		return rtc
	end

	def DisSRtools.getMatchFlagTopNum(aInAry,aPt,aTopNum)
		rtc = 0
		aInAry.each{|aItemAry|
			if(aItemAry[aPt] <= aTopNum)
				rtc += 1
			else
				break
			end
		}
		return rtc
	end

	def DisSRtools.getMatchFlagLowNum(aInAry,aPt,aLowIntPar)
		rtc = 0
		aInAry.each{|aItemAry|
			(topNo,intPar) = aItemAry
			if(intPar <= aLowIntPar)
				rtc += 1
			end
		}
		return rtc
	end

	def DisSRtools.getMatchIntAry(aMatchAry)
		rtcSum = 0
		rtcMax = nil
		aMatchAry.each{|aVal|
			if(aVal == nil)
				next
			end
			if(rtcMax == nil)
				rtcMax = aVal
			elsif(rtcMax < aVal)
				rtcMax = aVal
			end
			rtcSum += aVal
		}
		if(rtcMax == nil)
			rtcMax = ''
		end
#p rtcMax,rtcSum
#exit(0)
		return [rtcMax,rtcSum]
	end

	def DisSRtools.getMaxSeries(aMatchAry)
		rtcMaxSeries = 0
		rtcSeriesCount = 0
		seriesNum = 0
		beforeMatch = false
		aMatchAry.each_index{|i|
			if(aMatchAry[i] == nil)
				if(rtcMaxSeries < seriesNum)
					rtcMaxSeries = seriesNum
				end
				seriesNum = 0
				beforeMatch = false
				next
			end
			if(beforeMatch == true)
				rtcSeriesCount += 1
			end
			beforeMatch = true
			seriesNum += 1
		}
		if(rtcMaxSeries < seriesNum)
			rtcMaxSeries = seriesNum
		end
		return [rtcMaxSeries,rtcSeriesCount]
	end

	def DisSRtools.getMatchPointAry(aMatchAry)
		rtc = []
		aMatchAry.each_index{|i|
			if(aMatchAry[i] == nil)
				next
			end
			rtc.push(i)
		}
		return rtc
	end

	def DisSRtools.getMatchFlagName(aMatchFlagHash,aIonKind,aMatchAry)
		aMatchAry.each_index{|i|
			if(aMatchAry[i] == nil)
				next
			end
			ionName = "#{aIonKind}#{i+1}"
			aMatchFlagHash[ionName] = aMatchAry[i]
		}
	end

	def DisSRtools.titleMerge(aFileNoTitleAry)
		rtc = {}
		aFileNoTitleAry.each{|aKey,aTitleAry|
			aTitleAry.each{|aTitleStr,aNoUse|
				rtc[aTitleStr] = true
			}
		}
		return rtc.keys()
	end

	def DisSRtools.splitBYkindIon(aMatchFlagAryMerge)
		rtcBkind = {}
		rtcYkind = {}
		aMatchFlagAryMerge.each{|aIonKind,aMatchFlagPt|

			aMatchFlagPt.each{|aFlagNo,aVal|
				if(aIonKind == 'x' || aIonKind == 'y' || aIonKind == 'z')
					rtcYkind[aFlagNo] = aVal
				else
					rtcBkind[aFlagNo] = aVal
				end
			}
		}
		return [rtcBkind,rtcYkind]
	end

	def DisSRtools.getFragMatchCount(
			aFragMatchCount,aIonKind,aSeqLen,aIsBion)
		aIonKind.each{|aFlagNo,aVal|
			if(aIsBion == true)
				flagNoWk = aFlagNo
			else
				flagNoWk = aSeqLen - aFlagNo
			end
			if(aFragMatchCount[flagNoWk] == nil)
				aFragMatchCount[flagNoWk] = 1
				next
			end
			aFragMatchCount[flagNoWk] += 1
		}
	end

	def DisSRtools.getMatchUnmatchSum(aFragMatchCount,aChkLen)
		rtcBothMatch = 0
		rtcSingleMatch = 0
		rtcBothUnMatch = 0

		1.upto(aChkLen){|i|
			if(aFragMatchCount[i] == nil)
				rtcBothUnMatch += 1
			elsif(aFragMatchCount[i] <= 0)
				rtcBothUnMatch += 1
			elsif(aFragMatchCount[i] == 1)
				rtcSingleMatch += 1
			else
				rtcBothMatch += 1
			end
		}
		return [rtcBothMatch,rtcSingleMatch,rtcBothUnMatch]
	end

	def DisSRtools.get_byHitTag(aHitTagPtAry,aIonHitAry,aSeqLen,aPtMode)

		# 2019-3-4 tabaバグ対策
		# 最後のイオンがHitしていた場合
		# 最終のアミノ酸がhitしたことになる。
		ionHitAryWk = aIonHitAry.clone()
		if(ionHitAryWk[aSeqLen-1] == true)
			ionHitAryWk[aSeqLen] = true
		end

		beforeHit = true
		1.upto(aSeqLen){|i|
			if(ionHitAryWk[i] == nil)
				beforeHit = false
				next
			end

			if(beforeHit == false)
				beforeHit = true
				next
			end
			if(aPtMode == true)	# b-ion側
				wkPt = i
			else			# y-ion側
				wkPt = aSeqLen - i + 1
			end
			aHitTagPtAry[wkPt] = true
		}
	end

	def DisSRtools.get_byJoinTag(aHitTagPtAry,aKind1Ary,aKind2Ary,aSeqLen,aPtMode)
		aKind1Ary.each{|aPtWk,noUse|
			beforePt = aSeqLen - aPtWk + 1
			if(aKind2Ary[beforePt] == true)
				if(aPtMode == true)
					aHitTagPtAry[aPtWk] = true
				else
					aHitTagPtAry[beforePt] = true
				end
			end
			afterPt = aSeqLen - aPtWk - 1
			if(aKind2Ary[afterPt] == true)
				if(aPtMode == true)
					aHitTagPtAry[aPtWk+1] = true
				else
					aHitTagPtAry[afterPt+1] = true
				end
			end
		}
	end

	def DisSRtools.getTagAry(aHitTagPtAry,aSeqWk)

		rtcHitTag = []
		rtcHit = []
		rtcNoHit = []

		hitNum = 0
		noHitNum = 0
		hitAmiStr = ''

		seqLen = aSeqWk.length

		1.upto(seqLen){|i|
			if(aHitTagPtAry[i] == nil)
				noHitNum += 1
				if(hitNum > 0)
					rtcHit.push(hitNum)
					rtcHitTag.push(hitAmiStr)
				end
				hitNum = 0
				hitAmiStr = ''
			else
				seqCh = aSeqWk[i - 1]
				hitAmiStr = hitAmiStr + seqCh

				hitNum += 1
				if(noHitNum > 0)
					rtcNoHit.push(noHitNum)
				end
				noHitNum = 0
			end
		}
		if(hitNum > 0)
			rtcHit.push(hitNum)
			rtcHitTag.push(hitAmiStr)
		end
		if(noHitNum > 0)
			rtcNoHit.push(noHitNum)
		end
		return [rtcHitTag,rtcHit,rtcNoHit]
	end

	def DisSRtools.hashNestMerge(aHashTarget)
		rtc = {}
		aHashTarget.each{|aHashItemAry|
			aHashItemAry.each{|aIonKind,aHashAry|
				if(rtc[aIonKind] == nil)
					rtc[aIonKind] = aHashAry
				else
					rtc[aIonKind].merge!(aHashAry)
				end
			}
		}
		return rtc
	end

	def DisSRtools.getTagLenCount(aTagHitAry)
		rtc = {}
		rtcMax = 0
		aTagHitAry.each{|aTagLen|
			if(rtcMax < aTagLen)
				rtcMax = aTagLen
			end
			if(rtc[aTagLen] == nil)
				rtc[aTagLen] = 1
				next
			end
			rtc[aTagLen] += 1
		}
		return [rtc,rtcMax]
	end

	def DisSRtools.getTopItem(aMs2Ary,aPeakSelectVal)
		rtc = []
		setNum = 0
		sumIntensity = 0
		topIntensity = nil
		maxNum = aMs2Ary.length
		aMs2Ary.each{|aItemAry|
			(mzWk,intWk) = aItemAry
			if(topIntensity == nil)
				topIntensity = intWk
			end
			sumIntensity += intWk

			if(setNum >= aPeakSelectVal)
				break
			end
#			rtc.push([mzWk,intWk,setNum+1,(intWk.to_f()/topIntensity*100).round(0),maxNum])
			rtc.push([mzWk,intWk,setNum+1,(intWk.to_f()/topIntensity*100).round(4),maxNum])
			setNum += 1
		}
		return [rtc,setNum,topIntensity,sumIntensity]
	end

	def DisSRtools.getTopItemBin(aMs2Ary,aMinMz,aBinRange,aPeakSelectVal,aCancelFlagNo)
		binMs2Ary = {}
		fragNo = 0
		setNum = 0
		binNum = 0
		sumIntensity = 0
		topIntensity = nil
		maxNum = aMs2Ary.length
		aMs2Ary.each{|aItemAry|
			(mzWk,intWk) = aItemAry
			if(topIntensity == nil)
				topIntensity = intWk
			end
			sumIntensity += intWk

			fragNo += 1

			if(aCancelFlagNo[fragNo] != nil)
				next
			end

			binNo = ((mzWk - aMinMz) / aBinRange).to_i()
			if(binMs2Ary[binNo] == nil)
				binMs2Ary[binNo] = []
				binNum += 1
			end
			if(binMs2Ary[binNo].length >= aPeakSelectVal)
				next
			end

#			binMs2Ary[binNo].push([mzWk,intWk,setNum+1,(intWk.to_f()/topIntensity*100).round(0),maxNum])
#			binMs2Ary[binNo].push([mzWk,intWk,fragNo,(intWk.to_f()/topIntensity*100).round(0),maxNum])
			binMs2Ary[binNo].push([mzWk,intWk,fragNo,(intWk.to_f()/topIntensity*100).round(4),maxNum])
			setNum += 1
		}
#p aMs2Ary
#p "a1"
#p binMs2Ary,aMinMz
#exit(0)

		rtc = []
		binMs2Ary.each{|aBinNo,aBinMs2Ary|
			rtc += aBinMs2Ary
		}
#p rtc
#exit(0)
		return [rtc,setNum,binNum,topIntensity,sumIntensity]
	end

end


=begin
-----------------------------------------------------------------------------
	ScanNoHitGroup

	入力のCsvDataからHitしたペプチドを取り出し
	ScanNo+SeqKey+ModDetailKey毎の情報にグループ化する。
	（複数のピークリストのHitを生データのScanNo毎の情報に変換する）

	SeqKeyとは'I'を'L'に変換したSeqの事。
	ModDeatilKeyとは通常、重量が入っている情報をキーとして使えるように
	重量を削除する。
		ex)
			79.9663@S:1,79.9663@S:3,79.9663@S:5 を
			S:1,S:3,S:5 に変換する。

	そのグループの中に
	1.各ピークリスト+各サーチエンジンのScoreとPeptExptをまとめる。
		ex)Maxq/Mascot/8E-06/57.55,...

	2.ピークリスト毎のHit回数をまとめる。
		ex)Maxq/2,wizd/1,...

	3.サーチエンジン毎のHit回数をまとめる。
		ex)Mascot/2,Tandem/1,...

	全体の構成は以下
	scanNoHit => {"ScanNo+SeqKey+ModDetailKey"=>[
		BestHit-サーチエンジン,
		BestHit-inFileNo, ->オリジナルのHitDataの全てにアクセスするためのタイトル名がわかるようにするため
		"Maxq/Mascot/8E-06/57.55",
		"Maxq/2,wizd/1",
		"Mascot/2,Tandem/1",
		[オリジナルのHitDataの全て]
		[jPOSTscoreの情報]
		[ModDetailのチェックの情報]
	}]

	作成日 2017-08-07 taba
-----------------------------------------------------------------------------
=end

class ScanNoHitGroup
	def initialize()
	end

	def setInFileNo(aVal)
		@inFileNo = aVal
	end

	def setCsvData(aVal)
		@csvData = aVal
	end

	def setTitleAry(aVal)
		@titleAry = aVal
	end

	def setScanNoHit(aVal)
		@scanNoHit = aVal
	end

	def setTcomm(aVal)
		@tComm = aVal
	end

	def setTseq(aVal)
		@tSeq = aVal
	end

	def setTcharge(aVal)
		@tCharge = aVal
	end

	def setTmodDetail(aVal)
		@tModDetail = aVal
	end

	def setTplist(aVal)
		@tPlist = aVal
	end

	def setTengine(aVal)
		@tEngine = aVal
	end

	def setTpepScore(aVal)
		@tPepScore = aVal
	end

	def setTpepExpt(aVal)
		@tPepExpt = aVal
	end

	def setPsmUkey(aVal)
		@psmUkey = aVal
	end

	def check()
		if(@inFileNo.nil? == true)
			MyTools.printfAndExit(1,"@inFileNo is nill.",caller(0))
		end
		if(@csvData.nil? == true)
			MyTools.printfAndExit(1,"@csvData is nill.",caller(0))
		end
		if(@titleAry.nil? == true)
			MyTools.printfAndExit(1,"@titleAry is nill.",caller(0))
		end
		if(@scanNoHit.nil? == true)
			MyTools.printfAndExit(1,"@scanNoHit is nill.",caller(0))
		end
		if(@tComm.nil? == true)
			MyTools.printfAndExit(1,"@tComm is nill.",caller(0))
		end
		if(@tSeq.nil? == true)
			MyTools.printfAndExit(1,"@tSeq is nill.",caller(0))
		end
		if(@tCharge.nil? == true)
			MyTools.printfAndExit(1,"@tCharge is nill.",caller(0))
		end
		if(@tModDetail.nil? == true)
			MyTools.printfAndExit(1,"@tModDetail is nill.",caller(0))
		end
		if(@tPlist.nil? == true)
			MyTools.printfAndExit(1,"@tPlist is nill.",caller(0))
		end
		if(@tEngine.nil? == true)
			MyTools.printfAndExit(1,"@tEngine is nill.",caller(0))
		end
		if(@tPepScore.nil? == true)
			MyTools.printfAndExit(1,"@tPepScore is nill.",caller(0))
		end
		if(@tPepExpt.nil? == true)
			MyTools.printfAndExit(1,"@tPepExpt is nill.",caller(0))
		end
		if(@psmUkey.nil? == true)
			MyTools.printfAndExit(1,"@psmUkey is nill.",caller(0))
		end
	end

	def getEngineScore(aEngeneScoreAry,engeneKey)
		if(aEngeneScoreAry[engeneKey] == nil)
			MyTools.printfAndExit(1,"aEngeneScoreAry[#{engeneKey}] is nill.",caller(0))
#			return 0
		end
		return aEngeneScoreAry[engeneKey]
	end

	def getEngineTitle(aEngineScoreTitleAry,aEngeneKey)
		if(aEngineScoreTitleAry[aEngeneKey] == nil)
			MyTools.printfAndExit(1,"aEngineScoreTitleAry[#{aEngeneKey}] is nill.",caller(0))
		end
		return aEngineScoreTitleAry[aEngeneKey]
	end

	def setEngineScore(aEngScore,aEngTitleWk,aPepScore)
		if(aEngScore[aEngTitleWk] == nil)
			aEngScore[aEngTitleWk] = aPepScore
			return
		end
		if(aPepScore > aEngScore[aEngTitleWk])
			aEngScore[aEngTitleWk] = aPepScore
		end
	end

	def hitCountUpdate(aUpdateAry,aKey,aNum)
		if(aUpdateAry[aKey] == nil)
			aUpdateAry[aKey] = aNum
			return
		end
		aUpdateAry[aKey] += aNum
	end

	def exec()
		self.check()

		sEngineScore = {
			Pconst::S_ENG_MASCOT => 6,
			Pconst::S_ENG_MAX_QUANT => 5,
			Pconst::S_ENG_COMET => 4,
			Pconst::S_ENG_MSFRG => 3,
			Pconst::S_ENG_TANDEM => 2,
			Pconst::S_ENG_PILOT => 1,
		}

		sEngineScoreTitle = {
			Pconst::S_ENG_MASCOT => ReqFileType::CSV_SCORE_MASCOT,
			Pconst::S_ENG_MAX_QUANT => ReqFileType::CSV_SCORE_MAXQUANT,
			Pconst::S_ENG_COMET => ReqFileType::CSV_SCORE_COMET,
			Pconst::S_ENG_TANDEM => ReqFileType::CSV_SCORE_TANDEM,
			Pconst::S_ENG_PILOT => ReqFileType::CSV_SCORE_PILOT,
			Pconst::S_ENG_MSFRG => ReqFileType::CSV_SCORE_MSFRG,
		}


		@csvData[@tSeq].each_index{|i|
			comWk = @csvData[@tComm][i]
			seqWk = @csvData[@tSeq][i]
			chargeWk = @csvData[@tCharge][i]
			modDetailWk = @csvData[@tModDetail][i]
			plistWk = @csvData[@tPlist][i]
			engineWk = @csvData[@tEngine][i]
			pepScoreWk = @csvData[@tPepScore][i].to_f()
			@csvData[@tPepExpt][i].to_f()
			pepExptWk = sprintf("%.0e",@csvData[@tPepExpt][i].to_f())
			sEngTitleWk = self.getEngineTitle(sEngineScoreTitle,engineWk)


			seqWk = seqWk.gsub('I','L')
			if(modDetailWk == nil)
				modDetailWk = ''
			else
				modDetailWk = modDetailWk.gsub('I','L')
				modDetailWk = modDetailWk.gsub(/[0-9\.]+@/,'')
			end

			scanNoWk = DisSRtools.getScanNo(comWk)
			pListStrWk = DisSRtools.getPlistStr(plistWk)

			allItemAry = DisSRtools.getAllItem(@titleAry,@csvData,i)
			if(@psmUkey == DisSRconst::DSR_U_KEY_MOD_DETAIL)
				hitUniqueKey = "#{scanNoWk}/#{seqWk}/#{chargeWk}/#{modDetailWk}"
			else
				hitUniqueKey = "#{scanNoWk}/#{seqWk}/#{chargeWk}"
			end
			hitPlistEnginKey = "#{pListStrWk}/#{engineWk}/#{pepExptWk}/#{pepScoreWk}"
#p hitUniqueKey
#p hitPlistEnginKey
#p seqWk
#p modDetailWk
#p scanNoWk
#p pListStrWk
#p allItemAry
#exit(0)

			if(@scanNoHit[hitUniqueKey] == nil)
				@scanNoHit[hitUniqueKey] = [
					scanNoWk,
					engineWk,
					@inFileNo,
					[hitPlistEnginKey],
					{pListStrWk=>1},
					{engineWk=>1},
					allItemAry,
					pepScoreWk,
					{sEngTitleWk=>pepScoreWk}
				]
#p @scanNoHit
#exit(0)
				next
			end
			(bScanNoWk,bEngineWk,bInFileNo,plEngAry,plAry,engAry,bAllItemAry,bPepScore,bEngScore) = @scanNoHit[hitUniqueKey]
			nowEscore = self.getEngineScore(sEngineScore,engineWk)
			beforeEscore = self.getEngineScore(sEngineScore,bEngineWk)
			self.setEngineScore(bEngScore,sEngTitleWk,pepScoreWk)
#p nowEscore,engineWk
#p beforeEscore,bEngineWk
#exit(0)

			plEngAry.push(hitPlistEnginKey)
			self.hitCountUpdate(plAry,pListStrWk,1)
			self.hitCountUpdate(engAry,engineWk,1)
#p hitUniqueKey
#p plEngAry
#p plAry
#p engAry
#exit(0)


			if(beforeEscore > nowEscore)
				@scanNoHit[hitUniqueKey] = [bScanNoWk,bEngineWk,bInFileNo,plEngAry,plAry,engAry,bAllItemAry,bPepScore,bEngScore]
				next
			elsif(beforeEscore == nowEscore && bPepScore >= pepScoreWk)
				@scanNoHit[hitUniqueKey] = [bScanNoWk,bEngineWk,bInFileNo,plEngAry,plAry,engAry,bAllItemAry,bPepScore,bEngScore]
				next
			end

			@scanNoHit[hitUniqueKey] = [scanNoWk,engineWk,@inFileNo,plEngAry,plAry,engAry,allItemAry,pepScoreWk,bEngScore]
#p hitUniqueKey
#p allItemAry
#p bAllItemAry
#p hitUniqueKey
#p @scanNoHit[hitUniqueKey]
#exit(0)

		}
	end
end

=begin
-----------------------------------------------------------------------------
	PlistToMs2Data

	ピークリストファイル名とタイトルのHashからピークリストを
	読み出し、指定されたScanNoのみのMS2データを取り出す。
	その時のMS2データはIntensityの強いものから順に
	plistMzNum個取り出す。

	作成日 2017-08-08 taba
-----------------------------------------------------------------------------
=end

class PlistToMs2Data
	def initialize()
	end

	def setInFile(aVal)
		@inFile = aVal
	end

	def setComHash(aVal)
		@comHash = aVal
	end

	def setMs2KeyType(aVal)
		@ms2KeyType = aVal
	end

	def check()
		if(@inFile.nil? == true)
			MyTools.printfAndExit(1,"@inFile is nill.",caller(0))
		end
		if(@comHash.nil? == true)
			MyTools.printfAndExit(1,"@comHash is nill.",caller(0))
		end
		if(@ms2KeyType.nil? == true)
			MyTools.printfAndExit(1,"@ms2KeyType is nill.",caller(0))
		end
	end

	def getItemVal(aSep,aStr,aLineNo)
		(keyStr,valStr) = aStr.split(aSep,2)
		if(valStr == nil)
			p aStr
			MyTools.printfAndExit(1,"itemStr is mistake.(lineNo:#{aLineNo})",caller(0))
		end
		return [keyStr,valStr]
	end


	def exec()
		self.check()

		lineNo = 0
		comWk = nil
		ms2Ary = []
		rtc = {}

		fp = File.open(@inFile,File::RDONLY)
#p @inFile
#exit(0)
		while lineStr = fp.gets()
			lineNo += 1
			lineStr = lineStr.rstrip()

			if(lineStr == '')
				next
			end

			if(lineStr == 'BEGIN IONS')
				next
			end

			if(lineStr == 'END IONS')
				if(comWk == nil)
					next
				end

				minMz = 0.0
				if(ms2Ary[0] != nil)
					minMz = ms2Ary[0][0]
				end

				ms2Ary.sort!{|a,b|
					b[1] <=> a[1]
				}

				if(rtc[comWk] == nil)
					rtc[comWk] = [minMz,ms2Ary]
				end

				ms2Ary = []
				comWk = nil
			end

			if(lineStr.index('TITLE=') != nil)
				(noUse,titleWk) = self.getItemVal('=',lineStr,lineNo)
				scanNoWk = DisSRtools.getScanNo(titleWk)

				if(@ms2KeyType == DisSRconst::DSR_MS2_KEY_TITLE)
					ms2KeyWk = titleWk
				else
					ms2KeyWk = scanNoWk
				end

				if(@comHash[ms2KeyWk] != nil)
					comWk = ms2KeyWk
				end
				next
			end

			if(lineStr.index('=') != nil)
				next
			end

			if(comWk == nil)
				next
			end

			wkAry = lineStr.split(/ |\t/)
			if(wkAry.length < 2)
				p lineStr,scanNoWk
				MyTools.printfAndExit(1,"lineStr is mistake.(lineNo:#{lineNo})",caller(0))
			end
			ms2Ary.push([wkAry[0].to_f(),wkAry[1].to_f().round()])
		end

		fp.close()

		return rtc
	end
end

=begin
-----------------------------------------------------------------------------
	CalcjPOSTscore

	Seqから求めた論理ms2フラグメントと実測値とでHitしている
	フラグメントを探す。
	そのHitフラグメントを使いjPOSTscoreを計算する。
	修飾がある場合、ニュートラルロスのフラグメントも
	Hitしているかをチェックする。
	そして、そのニュートラルロスのHitフラグメントを使い
	修飾ポイントが正しいかのチェックも行う。（将来実装予定）

	作成日 2017-08-08 taba
-----------------------------------------------------------------------------
=end

class CalcjPOSTscore
	def initialize()
	end

	def setScanNoHit(aVal)
		@scanNoHit = aVal
	end

	def setMs2FlagAry(aVal)
		@ms2FlagAry = aVal
	end

	def setFileNoTitleAry(aVal)
		@fileNoTitleAry = aVal
	end

	def setMs2TolL(aVal)
		@ms2TolL = aVal
	end

	def setMs2TolR(aVal)
		@ms2TolR = aVal
	end

	def setMs2TolU(aVal)
		@ms2TolU = aVal
	end

	def setMs2IonKindAry(aVal)
		@ms2IonKindAry = aVal
	end

	def setInFileType(aVal)
		@inFileType = aVal
	end

	def setMs2KeyType(aVal)
		@ms2KeyType = aVal
	end

	def setTseq(aVal)
		@tSeq = aVal
	end

	def setTmodDetail(aVal)
		@tModDetail = aVal
	end

	def setTcharge(aVal)
		@tCharge = aVal
	end

	def setTpeakList(aVal)
		@tPeakList = aVal
	end

	def setTcomm(aVal)
		@tComm = aVal
	end

	def setTcalcMz(aVal)
		@tCalcMz = aVal
	end

	def setPepCountFile(aVal)
		@pepCountFile = aVal
	end

	def setJpostScoreMin(aVal)
		@jPostScoreMin = aVal
	end

	def setKeyToJpostScore(aVal)
		@keyToJpostScore = aVal
	end

	def setMs2PeakSelectBin(aVal)
		@ms2PeakSelectBin = aVal
	end

	def setBinRange(aVal)
		@binRange = aVal
	end

	def setPlistMzNum(aVal)
		@plistMzNum = aVal
	end

	def setMaxFlagCharge(aVal)
		@maxFlagCharge = aVal
	end

	def setUniScCstAry(aVal)
		@uniScCstAry = aVal
	end

	def check()
		if(@scanNoHit.nil? == true)
			MyTools.printfAndExit(1,"@scanNoHit is nil.",caller(0))
		end
		if(@ms2FlagAry.nil? == true)
			MyTools.printfAndExit(1,"@ms2FlagAry is nil.",caller(0))
		end
		if(@fileNoTitleAry.nil? == true)
			MyTools.printfAndExit(1,"@fileNoTitleAry is nil.",caller(0))
		end
		if(@ms2TolL.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolL is nil.",caller(0))
		end
		if(@ms2TolR.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolR is nil.",caller(0))
		end
		if(@ms2TolU.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolU is nil.",caller(0))
		end
		if(@ms2IonKindAry.nil? == true)
			MyTools.printfAndExit(1,"@ms2IonKindAry is nil.",caller(0))
		end
		if(@inFileType.nil? == true)
			MyTools.printfAndExit(1,"@inFileType is nil.",caller(0))
		end
		if(@ms2KeyType.nil? == true)
			MyTools.printfAndExit(1,"@ms2KeyType is nil.",caller(0))
		end
		if(@tSeq.nil? == true)
			MyTools.printfAndExit(1,"@tSeq is nil.",caller(0))
		end
		if(@tModDetail.nil? == true)
			MyTools.printfAndExit(1,"@tModDetail is nil.",caller(0))
		end
		if(@tCharge.nil? == true)
			MyTools.printfAndExit(1,"@tCharge is nil.",caller(0))
		end
		if(@tPeakList.nil? == true)
			MyTools.printfAndExit(1,"@tPeakList is nil.",caller(0))
		end
		if(@tComm.nil? == true)
			MyTools.printfAndExit(1,"@tComm is nil.",caller(0))
		end
		if(@tCalcMz.nil? == true)
			MyTools.printfAndExit(1,"@tCalcMz is nil.",caller(0))
		end
		if(@pepCountFile.nil? == true)
			MyTools.printfAndExit(1,"@pepCountFile is nil.",caller(0))
		end
		if(@jPostScoreMin.nil? == true)
			MyTools.printfAndExit(1,"@jPostScoreMin is nil.",caller(0))
		end
#		if(@keyToJpostScore.nil? == true)
#			MyTools.printfAndExit(1,"@keyToJpostScore is nil.",caller(0))
#		end
		if(@ms2PeakSelectBin.nil? == true)
			MyTools.printfAndExit(1,"@ms2PeakSelectBin is nil.",caller(0))
		end
		if(@binRange.nil? == true)
			MyTools.printfAndExit(1,"@binRange is nil.",caller(0))
		end
		if(@plistMzNum.nil? == true)
			MyTools.printfAndExit(1,"@plistMzNum is nil.",caller(0))
		end
		if(@maxFlagCharge.nil? == true)
			MyTools.printfAndExit(1,"@maxFlagCharge is nil.",caller(0))
		end
		if(@uniScCstAry.nil? == true)
			MyTools.printfAndExit(1,"@uniScCstAry is nil.",caller(0))
		end
	end

	def ms2Match(aStdFalgAry,aMs2Flag,aMs2mzCenter,aMs2TolL,aMs2TolR,
			aMs2TolU,aSeqLen,aIonKind,aNlKey,aMatchFlagPt,aChgWk,
			aMatchFlagDetail,aMatchFlagIntNo,aAllFlagToMatch,
			aCancelFragNoWk)

		stdPt = 0
		rawPt = 0
		rtcDiffAry = []
		matchAry = []
		matchFlagPtWk = {}
#print "start\n"
#p aStdFalgAry,aMs2Flag
#exit(0)

#p aMs2TolL,aMs2TolR,aMs2TolU
#exit(0)

		aStdFalgAry.each_index{|stdPt|
			(flagNo,stdMz) = aStdFalgAry[stdPt]
			chargeStr = "+" * aChgWk
			nlStr = ''
			if("#{aNlKey}" != '')
				nlStr = "-#{aNlKey}"
			end
			allFlagKey = "#{aIonKind}#{flagNo}#{nlStr}#{chargeStr}"
			aAllFlagToMatch[allFlagKey] = false
		}
#p aAllFlagToMatch
#exit(0)

		while(true) do
			if(stdPt >= aStdFalgAry.length)
				break
			end
			if(rawPt >= aMs2Flag.length)
				break
			end

			(flagNo,stdMz) = aStdFalgAry[stdPt]
			(rawMz,rawInt,setNo,intParcent,maxNum) = aMs2Flag[rawPt]
			if(aIonKind == 'x' || aIonKind == 'y' || aIonKind == 'z')
# 2019-03-18 taba Ver0.26
#				flagPt = aSeqLen - flagNo + 1
				flagPt = aSeqLen - flagNo
			else
				flagPt = flagNo
			end
#print "#{aIonKind}-#{flagNo}-#{flagPt}-#{aSeqLen}-#{aChgWk}\n"


#print "#{stdPt}-#{rawPt}\n"
#print "#{stdMz}-#{rawMz}\n"


			mzRangeL = SeqStrTools.getDiffDa(stdMz,aMs2TolL,aMs2TolU)
			mzRangeR = SeqStrTools.getDiffDa(stdMz,aMs2TolR,aMs2TolU)
			mzRangeCenter = SeqStrTools.getDiffDa(rawMz,aMs2mzCenter,aMs2TolU)
#p mzRangeL,mzRangeR,mzRangeCenter,rawMz,stdMz
#p aMs2mzCenter,mzRangeCenter
#exit(0)

			rawMz -= mzRangeCenter
			stdMzLow = stdMz - mzRangeL
			stdMzHeigh = stdMz + mzRangeR

			chargeStr = "+" * aChgWk
			nlStr = ''
			if("#{aNlKey}" != '')
				nlStr = "-#{aNlKey}"
			end
			allFlagKey = "#{aIonKind}#{flagNo}#{nlStr}#{chargeStr}"
#print "#{allFlagKey}\n"
#print "#{rawMzLow}-#{rawMzHeigh}\n"
#p allFlagKey
#exit(0)

			if(stdMzLow <= rawMz && rawMz <= stdMzHeigh)
#print  "match\n"

				diffValDa = rawMz - stdMz
#p diffVal
				if(SeqStrTools::PPM_STR == aMs2TolU)
					diffValConv = DisSRtools.getDiffPpm(rawMz,diffValDa)
				else
					diffValConv = diffValDa
				end

#p diffVal,aMs2TolU
#exit(0)

				rtcDiffAry.push([stdMz,diffValDa,diffValConv])
				matchAry[flagNo] = rawInt
				aMatchFlagPt[flagPt] = true
				matchFlagPtWk[flagNo] = true
#				aMatchFlagDetail.push("#{aIonKind}#{flagNo}#{aNlKey}+#{aChgWk}:#{setNo}:#{intParcent}:#{maxNum}")
				aMatchFlagDetail.push("#{aIonKind}#{flagNo}#{nlStr}#{chargeStr}:#{setNo}:#{intParcent}:#{maxNum}")
#puts "#{aIonKind}#{flagNo}:#{setNo}:#{intParcent}:#{maxNum},#{stdMz},#{rawMz}"

#p aMatchFlagDetail
#exit(0)

				aMatchFlagIntNo[setNo] = intParcent
				rawPt += 1
				stdPt += 1
				aAllFlagToMatch[allFlagKey] = true
				aCancelFragNoWk[setNo] = true
				next
			end
#print  "unmatch\n"

			if(rawMz <= stdMz)
				rawPt += 1
			else
				stdPt += 1
			end
		end
#p matchAry
#exit(0)

		(rtcMaxSeries,rtcSeriesCount) = DisSRtools.getMaxSeries(matchAry)
#p rtcMaxSeries,rtcSeriesCount,rtcDiffAry
#exit(0)
#p aAllFlagToMatch
#exit(0)

		return [rtcMaxSeries,rtcDiffAry,matchAry,rtcSeriesCount,matchFlagPtWk]
	end

	def ms2PreMatch(
		aStdFalgAry,aMs2Flag,aMs2mzCenter,aMs2TolL,aMs2TolR,aMs2TolU)

		stdPt = 0
		rawPt = 0
		rtcSumInt = 0

		while(true) do
			if(stdPt >= aStdFalgAry.length)
				break
			end
			if(rawPt >= aMs2Flag.length)
				break
			end

			stdMz = aStdFalgAry[stdPt]
			(rawMz,rawInt,setNo,intParcent,maxNum) = aMs2Flag[rawPt]
			mzRangeL = SeqStrTools.getDiffDa(stdMz,aMs2TolL,aMs2TolU)
			mzRangeR = SeqStrTools.getDiffDa(stdMz,aMs2TolR,aMs2TolU)
			mzRangeCenter = SeqStrTools.getDiffDa(rawMz,aMs2mzCenter,aMs2TolU)
#p mzRangeL,mzRangeR,mzRangeCenter,rawMz,stdMz
#p aMs2mzCenter,mzRangeCenter
#exit(0)

			rawMz -= mzRangeCenter
			stdMzLow = stdMz - mzRangeL
			stdMzHeigh = stdMz + mzRangeR


			if(stdMzLow <= rawMz && rawMz <= stdMzHeigh)
#print  "match:#{rtcSumInt}:#{rawInt}\n"
				rtcSumInt += rawInt

				rawPt += 1
				stdPt += 1

				next
			end
#print  "unmatch:#{stdMzLow}:#{rawMz}:#{stdMzHeigh}\n"

			if(rawMz <= stdMz)
				rawPt += 1
			else
				stdPt += 1
			end
		end
		return rtcSumInt
	end

	def getDiffValAvg(aDiffAry)
		rtc = []
		sumDiffVal = 0.0
		if(aDiffAry.length <= 0)
			return [sumDiffVal,rtc]
		end
		aDiffAry.each{|aItemAry|
			(stdMz,diffValDa,diffValConv) = aItemAry
			sumDiffVal += diffValConv
			rtc.push([stdMz,diffValDa])
		}
		diffValAvg = sumDiffVal / aDiffAry.length
		return [diffValAvg,rtc]
	end

	def exec()
		self.check()

		flagObj = MS2FlagWeight.new()
		chemWeiObj = ChemWeight.new()
		phosphoNLw = chemWeiObj.calChemWeight('H3O4P',ChemWeight::MONO_MASS_PT)
#p phosphoNLw
#exit(0)

		# ペプチドの部分配列の個数を数えたデータファイルを読み込む
		(tagCountMin,convStrFrom,convStrTo,tagSeqAry) = JSON.parse(File.read(@pepCountFile))


		rtc = {}
		keyToJpostScore = {}
		cancelFragNo = {}
		saveMaxTagLen = 0

		if(@keyToJpostScore == nil)
			scanNoKeyWk = @scanNoHit
		else
			scanNoKeyWk = @keyToJpostScore
		end

		scanNoKeyWk.each_key{|aKey|
			(scanNoWk,noUse,inFileNo,noUse,noUse,noUse,allItemAry,pepScoreWk,noUse) = @scanNoHit[aKey]

			if(@keyToJpostScore == nil)
				ms2mzCenter = 0.0
			else
				ms2mzCenter = @keyToJpostScore[aKey][1]
			end
#p ms2mzCenter
#exit(0)

			titleNoAry = @fileNoTitleAry[inFileNo]
			seqWk = DisSRtools.getItemData(titleNoAry,@tSeq,allItemAry)
			modDetailWk = DisSRtools.getItemData(titleNoAry,@tModDetail,allItemAry)
			chargeWk = DisSRtools.getItemData(titleNoAry,@tCharge,allItemAry)
			peakListWk = DisSRtools.getItemData(titleNoAry,@tPeakList,allItemAry)
			commWk = DisSRtools.getItemData(titleNoAry,@tComm,allItemAry)
			calcMzWk = DisSRtools.getItemData(titleNoAry,@tCalcMz,allItemAry).to_f()

			if(@ms2KeyType == DisSRconst::DSR_MS2_KEY_TITLE)
				ms2KeyWk = commWk
			else
				ms2KeyWk = scanNoWk
			end

#p aKey
#p calcMzWk
#p @tCalcMz
#p allItemAry
#p titleNoAry
#p titleNoAry
#p seqWk
#p modDetailWk
#p chargeWk
#p peakListWk
#p commWk
#p ms2KeyWk
#exit(0)


			if(@ms2FlagAry[peakListWk] == nil)
				MyTools.printfAndExit(1,"@ms2FlagAry[#{peakListWk}] is nil.",caller(0))
			end
			if(@ms2FlagAry[peakListWk][ms2KeyWk] == nil)
				MyTools.printfAndExit(1,"@ms2FlagAry[#{peakListWk}][#{ms2KeyWk}] is nil.",caller(0))
			end

			if(cancelFragNo[peakListWk] == nil)
				cancelFragNo[peakListWk] = {}
			end
			if(cancelFragNo[peakListWk][ms2KeyWk] == nil)
				cancelFragNo[peakListWk][ms2KeyWk] = {}
			end

			(minMz,ms2FlagWk) = @ms2FlagAry[peakListWk][ms2KeyWk]
#p "a1"
#p peakListWk,ms2KeyWk

			if(@keyToJpostScore == nil)
				cancelFragNoWk = {}
			else
				cancelFragNoWk = cancelFragNo[peakListWk][ms2KeyWk]
			end

			if(@ms2PeakSelectBin == DisSRconst::DSR_MS2_M_BIN_MZ_Y)
				(ms2FlagWk,ms2FlagSetNum,binNum,
				ms2MaxInt,ms2SumInt) = 
					DisSRtools.getTopItemBin(ms2FlagWk,minMz,@binRange,@plistMzNum,cancelFragNoWk)
			else
				(ms2FlagWk,ms2FlagSetNum,
				ms2MaxInt,ms2SumInt) = 
					DisSRtools.getTopItem(ms2FlagWk,@plistMzNum)
			end

			rtcCancelFragNo = cancelFragNoWk.clone()

#p "a2"
#p ms2MaxInt
#p ms2SumInt
#p ms2FlagWk
#exit(0)

			ms2FlagWk.sort!{|a,b|
				a[0] <=> b[0]
			}

			seqLen = seqWk.length
			chargeWk = chargeWk.to_i()

			if(chargeWk <= 0)
#				chargeWk = -1
				if(chargeWk <= -1)
					chargeWk += 1
				end
			else
#				chargeWk = 1
				if(chargeWk > 1)
					chargeWk -= 1
				end
			end

=begin
			# フラグメントのチェックは最大２価までとする。
			# 2018-09-19
			if(chargeWk > 2)
				chargeWk = 2
			end
=end

#p chargeWk,@maxFlagCharge
#exit(0)
			# フラグメントのチェックは最大１価までとする。
			# 2019-04-09
			if(chargeWk > @maxFlagCharge)
				chargeWk = @maxFlagCharge
			end

			chargeAryWk = DisSRtools.getFromToAry(1,chargeWk)

			(convPhoNLmodN,convPhoNLmodC) = flagObj.convNLmodAry(
#				modDetailWk,seqLen,['79.9663','p',phosphoNLw,],
				modDetailWk,seqLen,['79.9663',phosphoNLw.round(),phosphoNLw,],
				{'Y'=>true}
			)
#if(convPhoNLmodN.length > 1)
#p scanNoWk
#p seqWk
#p chargeWk
#p modDetailWk
#p convPhoNLmodN
#p convPhoNLmodC
#exit(0)
#end

			convMod = flagObj.convModAry(modDetailWk)
			stdMs2Flag = flagObj.getAllFlagment(seqWk,chargeAryWk,convMod)

			nlMs2Flag = {}
			flagObj.getNLallFlagment(nlMs2Flag,stdMs2Flag,convPhoNLmodN,PepWeight::NTERM_STR)
			flagObj.getNLallFlagment(nlMs2Flag,stdMs2Flag,convPhoNLmodC,PepWeight::CTERM_STR)

#if(convPhoNLmodN.length > 1)
#p stdMs2Flag,nlMs2Flag
#exit(0)
#end

			convPhoNLmodN = nil
			convPhoNLmodC = nil


			sumStdFlagNum = 0
			allDiffAry = []
			maxSeries = 0
			seriesCount = 0
			matchFlagStr = []
			matchFlagChg = {}
			matchFlagKind = {}
			matchFlagPt = {}
			matchFlagHash = {}
			matchFlagDetail = []
			matchFlagIntNo = {}
			matchFlagAryMerge = {}
			matchNLflagAryMerge = {}
			matchFlagAryAll = []
			allFlagToMatch = {}
			@ms2IonKindAry.each{|aIonKind|
				stdChgFlagAry = stdMs2Flag[aIonKind]
				stdChgFlagAry.each{|aChgWk,aStdFalgAry|

					aStdFalgAry = aStdFalgAry.sort()

					(seriesNum,hitDiffAry,matchFlagAry,seriesCountWk,matchIonNoPt) = 
						self.ms2Match(
							aStdFalgAry,
							ms2FlagWk,
							ms2mzCenter,
							@ms2TolL,
							@ms2TolR,
							@ms2TolU,
							seqLen,
							aIonKind,
							'',
							matchFlagPt,
							aChgWk,
							matchFlagDetail,
							matchFlagIntNo,
							allFlagToMatch,
							cancelFragNoWk,
						)
					sumStdFlagNum += aStdFalgAry.length
					allDiffAry += hitDiffAry
					if(maxSeries < seriesNum)
						maxSeries = seriesNum
					end
					if(matchFlagAry.length > 0)
						matchFlagStr.push("#{aIonKind}:#{aChgWk}@" + DisSRtools.getMatchPointAry(matchFlagAry).join(':'))
					end
					 DisSRtools.getMatchFlagName(matchFlagHash,aIonKind,matchFlagAry)
					if(matchFlagChg[aChgWk] == nil)
						matchFlagChg[aChgWk] = hitDiffAry.length
					else
						matchFlagChg[aChgWk] += hitDiffAry.length
					end
					if(matchFlagKind[aIonKind] == nil)
						matchFlagKind[aIonKind] = hitDiffAry.length
					else
						matchFlagKind[aIonKind] += hitDiffAry.length
					end
					if(matchFlagAryMerge[aIonKind] == nil)
						matchFlagAryMerge[aIonKind] = matchIonNoPt
					else
						matchFlagAryMerge[aIonKind].merge!(matchIonNoPt)
					end
					seriesCount += seriesCountWk
					matchFlagAryAll += matchFlagAry
#p matchFlagAry,matchFlagStr,matchFlagPt
#exit(0)
				}
			}


			nlMs2Flag.each{|aNlKey,aMs2IonKindAry|
				aMs2IonKindAry.each{|aIonKind,aStdChgFlagAry|

					if(@ms2IonKindAry.include?(aIonKind) == false)
						next
					end

#print "flagKind=#{aIonKind}\n"
					aStdChgFlagAry.each{|aChgWk,aStdFalgAry|
#print "charge=#{aChgWk}\n"
#p aStdFalgAry

						aStdFalgAry = aStdFalgAry.sort()
#p aStdFalgAry
#p ms2FlagWk
#exit(0)
						(seriesNum,hitDiffAry,matchFlagAry,seriesCountWk,matchIonNoPt) = 
							self.ms2Match(
								aStdFalgAry,
								ms2FlagWk,
								ms2mzCenter,
								@ms2TolL,
								@ms2TolR,
								@ms2TolU,
								seqLen,
								aIonKind,
								aNlKey,
								matchFlagPt,
								aChgWk,
								matchFlagDetail,
								matchFlagIntNo,
								allFlagToMatch,
								cancelFragNoWk,
							)
						sumStdFlagNum += aStdFalgAry.length
						allDiffAry += hitDiffAry
						if(matchFlagAry.length > 0)
							matchFlagStr.push("#{aIonKind}+#{aNlKey}:#{aChgWk}@" + DisSRtools.getMatchPointAry(matchFlagAry).join(':'))
						end
#						 DisSRtools.getMatchFlagName(matchFlagHash,"#{aIonKind}#{aNlKey}",matchFlagAry)
						if(matchFlagChg[aChgWk] == nil)
							matchFlagChg[aChgWk] = hitDiffAry.length
						else
							matchFlagChg[aChgWk] += hitDiffAry.length
						end
						if(matchFlagKind[aIonKind] == nil)
							matchFlagKind[aIonKind] = hitDiffAry.length
						else
							matchFlagKind[aIonKind] += hitDiffAry.length
						end
						if(matchNLflagAryMerge[aIonKind] == nil)
							matchNLflagAryMerge[aIonKind] = matchIonNoPt
						else
							matchNLflagAryMerge[aIonKind].merge!(matchIonNoPt)
						end

						matchFlagAryAll += matchFlagAry
					}
				}
			}
#p allFlagToMatch
#p allDiffAry,allDiffAry.length
#exit(0)


			allDiffAry.sort!{|a,b|
				a[0] <=> b[0]
			}

			(diffValAvg,allDiffAry) = self.getDiffValAvg(allDiffAry)

#p seqWk,matchFlagPt,seqLen,matchFlagAryMerge
#p "z1"
#p matchFlagDetail,matchNLflagAryMerge,matchFlagIntNo,allFlagToMatch,matchFlagAryAll
#exit(0)
#p allDiffAry,allDiffAry.length,diffValAvg
#exit(0)

			matchFlagAryMerge = DisSRtools.hashNestMerge([matchFlagAryMerge,matchNLflagAryMerge])

#p "z2"
#p matchFlagAryMerge
#exit(0)


			(bKind,yKind) = DisSRtools.splitBYkindIon(matchFlagAryMerge)
#p "z3"
#p matchFlagAryMerge,bKind,yKind
#exit(0)


			bTagPtAry = {}
			yTagPtAry = {}
			allTagPtAry ={}

=begin
			# b-Hit
			DisSRtools.get_byHitTag(bTagPtAry,bKind,seqLen,true)
			(bTagSeqAry,bTagLenAry,bTagNoHitLenAry) = 
				DisSRtools.getTagAry(bTagPtAry,seqWk)

			# y-Hit
			wkStr = seqWk[1,seqLen-1]
			DisSRtools.get_byHitTag(yTagPtAry,yKind,seqLen,false)
			(yTagSeqAry,yTagLenAry,yTagNoHitLenAry) = 
				DisSRtools.getTagAry(yTagPtAry,seqWk)
=end

#p "a1"
#p seqWk,seqLen
#p bTagSeqAry,bTagLenAry,bTagNoHitLenAry,bTagPtAry,bKind
#p "a2"
#p yTagSeqAry,yTagLenAry,yTagNoHitLenAry,yTagPtAry,yKind
#exit(0)


			# b+y-Hit
			DisSRtools.get_byHitTag(allTagPtAry,bKind,seqLen,true)
#p "a3"
#p allTagPtAry
			DisSRtools.get_byHitTag(allTagPtAry,yKind,seqLen,false)
#p allTagPtAry

			DisSRtools.get_byJoinTag(allTagPtAry,bKind,yKind,seqLen,true)
#p allTagPtAry

			DisSRtools.get_byJoinTag(allTagPtAry,yKind,bKind,seqLen,false)
#p allTagPtAry
#exit(0)
			(allTagSeqAry,allTagLenAry,allTagNoHitLenAry) = 
				DisSRtools.getTagAry(allTagPtAry,seqWk)
#p "a4"
#p allTagSeqAry,allTagLenAry,allTagNoHitLenAry
#exit(0)
#p "a5"
#p matchFlagAryMerge,seqLen,seqWk



			# イオンHitの数を数える
			fragMatchCount = {}
			DisSRtools.getFragMatchCount(fragMatchCount,bKind,seqLen,true)
			DisSRtools.getFragMatchCount(fragMatchCount,yKind,seqLen,false)
#p fragMatchCount
#exit(0)

			(bothMatch,singleMatch,bothUnMatch) = 
				DisSRtools.getMatchUnmatchSum(fragMatchCount,seqLen-1)
#p fragMatchCount,bothMatch,singleMatch,bothUnMatch
#exit(0)


			# スコア計算用の数を揃える
			bothMatchWk = [bothMatch]
			singleMatchWk = [singleMatch]
			bothUnMatchWk = [bothUnMatch]

=begin
			allTagHitWk = bTagLenAry + yTagLenAry + allTagLenAry
			allTagNoHitWk = bTagNoHitLenAry + yTagNoHitLenAry + allTagNoHitLenAry
			allTagSeqWk = bTagSeqAry + yTagSeqAry + allTagSeqAry
=end

			allTagHitWk = allTagLenAry
			allTagNoHitWk = allTagNoHitLenAry
			allTagSeqWk = allTagSeqAry
#p allTagHitWk,allTagNoHitWk,allTagSeqWk
#exit(0)


			tagLenAryWk = {
#				'b' => bTagLenAry,
#				'y' => yTagLenAry,
				'b+y' => allTagLenAry,
			}
			allTagLenCount = {}
			rtcMaxTagLen = 0
			tagLenAryWk.each{|aKey,aTagLenAry|
				(allTagLenCountWk,maxTagLen) = DisSRtools.getTagLenCount(allTagHitWk)
				allTagLenCount[aKey] = allTagLenCountWk
				if(saveMaxTagLen < maxTagLen)
					saveMaxTagLen = maxTagLen
				end
				if(rtcMaxTagLen < maxTagLen)
					rtcMaxTagLen = maxTagLen
				end
			}

#p "a9"
#p allTagLenCount,rtcMaxTagLen
#exit(0)


			rtcHitFlagPt =  matchFlagPt.length.to_f() / seqLen * 100

			(rtcJpostScore,rtcBothMatchSum,rtcSingleMatchSum,
			rtcBothUnMatchSum,rtcTagHitSum,rtcNoTagHitSum) = 
				DisSRtools.getJpostScoreV2(
					bothMatchWk,singleMatchWk,
					bothUnMatchWk,
					allTagHitWk,allTagNoHitWk,
					matchFlagIntNo.keys(),seqLen,
					@uniScCstAry
				)
#p "aaa"
#p rtcJpostScore
#exit(0)


# TagScoreの評価のために一時的にコメント化 2019-04-26 taba
=begin
			keyToJpostScore[aKey] = [rtcJpostScore,diffValAvg]
			if(@keyToJpostScore == nil)
				next
			end
=end



			if(rtcJpostScore < @jPostScoreMin)
				next
			end

			rtcHitPartSeq = DisSRtools.getPartSeq(allTagSeqWk,tagSeqAry,convStrFrom,convStrTo)
#p rtcJpostScore,rtcHitPartSeq,@ms2TolL,@ms2TolR,ms2mzCenter
#exit(0)
#p allDiffAry

			rtcHitNum = [sumStdFlagNum,allDiffAry.length]
			rtcHitDiff = allDiffAry
			rtcMaxSeries = maxSeries
			rtcSeriesCount = seriesCount
			rtcHitNumStr = "#{allDiffAry.length}@#{sumStdFlagNum}"
			rtcHitFlagStr = matchFlagStr.join(',')
			rtcHitFlagChg = DisSRtools.getKeyValStr(matchFlagChg)
			rtcHitFlagKind = DisSRtools.getKeyValStr(matchFlagKind)

			rtcHitFlagHash = matchFlagHash
			rtcMatchFlagCount = matchFlagDetail.length
			rtcMatchFlagDetail = matchFlagDetail.join(',')

			matchFlagSorted = matchFlagIntNo.sort{|(k1,v1),(k2,v2)|
				k1 <=> k2
			}

			rtcMatchFlagIntNo = DisSRtools.getAryPointToAry(matchFlagSorted,0).join(',')
			rtcMatchFlagIntPar = DisSRtools.getAryPointToAry(matchFlagSorted,1).join(',')
			rtcMatchFlagTop10 = DisSRtools.getMatchFlagTopNum(matchFlagSorted,0,10)
			rtcMatchFlagLow5 = DisSRtools.getMatchFlagLowNum(matchFlagSorted,0,5)

			(rtcMs2IntMax,rtcMs2IntSum) = DisSRtools.getMatchIntAry(matchFlagAryAll)
			wkAry = allTagPtAry.keys()
			rtcMatchAmiPt = wkAry.sort()
#if(convPhoNLmodN.length > 1)
#p allFlagToMatch
#exit(0)
#end

			ms2PreInt = self.ms2PreMatch([calcMzWk],ms2FlagWk,
				ms2mzCenter,@ms2TolL,@ms2TolR,@ms2TolU)

			rtcMs2Info = [ms2MaxInt,ms2SumInt,ms2PreInt]
#p rtcMs2Info
#exit(0)

			rtc[aKey] = [rtcHitFlagPt,rtcJpostScore,rtcHitPartSeq,rtcHitNum,rtcHitDiff,rtcMaxSeries,rtcSeriesCount,rtcHitNumStr,rtcHitFlagStr,rtcHitFlagChg,rtcHitFlagKind,rtcHitFlagHash,rtcMatchFlagDetail,rtcMatchFlagIntNo,rtcMatchFlagIntPar,rtcMatchFlagTop10,rtcMatchFlagLow5,rtcMs2IntMax,rtcMs2IntSum,rtcMatchFlagCount,rtcMatchAmiPt,allFlagToMatch,allTagLenCount,rtcMaxTagLen,rtcCancelFragNo,ms2mzCenter,rtcBothMatchSum,rtcSingleMatchSum,rtcBothUnMatchSum,allTagHitWk,allTagNoHitWk,ms2FlagSetNum,rtcMs2Info]

#p rtc
#exit(0)
		}
#p keyToJpostScore
#exit(0)

		return [rtc,saveMaxTagLen,keyToJpostScore]
	end
end

=begin
-----------------------------------------------------------------------------
	SearchImmoniumIon

	Seqから求めたImmoniumイオンフラグメントと
	実測値とでHitしているフラグメントを探す。

	作成日 2019-08-21 taba
-----------------------------------------------------------------------------
=end

class SearchImmoniumIon
	def initialize()
	end

	def setScanNoHit(aVal)
		@scanNoHit = aVal
	end

	def setMs2FlagAry(aVal)
		@ms2FlagAry = aVal
	end

	def setFileNoTitleAry(aVal)
		@fileNoTitleAry = aVal
	end

	def setMs2TolL(aVal)
		@ms2TolL = aVal
	end

	def setMs2TolR(aVal)
		@ms2TolR = aVal
	end

	def setMs2TolU(aVal)
		@ms2TolU = aVal
	end

	def setMs2KeyType(aVal)
		@ms2KeyType = aVal
	end

	def setTseq(aVal)
		@tSeq = aVal
	end

	def setTpeakList(aVal)
		@tPeakList = aVal
	end

	def setTcomm(aVal)
		@tComm = aVal
	end

	def setKeyToJpostScore(aVal)
		@keyToJpostScore = aVal
	end

	def setMs2PeakSelectBin(aVal)
		@ms2PeakSelectBin = aVal
	end

	def setBinRange(aVal)
		@binRange = aVal
	end

	def setPlistMzNum(aVal)
		@plistMzNum = aVal
	end

	def check()
		if(@scanNoHit.nil? == true)
			MyTools.printfAndExit(1,"@scanNoHit is nil.",caller(0))
		end
		if(@ms2FlagAry.nil? == true)
			MyTools.printfAndExit(1,"@ms2FlagAry is nil.",caller(0))
		end
		if(@fileNoTitleAry.nil? == true)
			MyTools.printfAndExit(1,"@fileNoTitleAry is nil.",caller(0))
		end
		if(@ms2TolL.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolL is nil.",caller(0))
		end
		if(@ms2TolR.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolR is nil.",caller(0))
		end
		if(@ms2TolU.nil? == true)
			MyTools.printfAndExit(1,"@ms2TolU is nil.",caller(0))
		end
		if(@ms2KeyType.nil? == true)
			MyTools.printfAndExit(1,"@ms2KeyType is nil.",caller(0))
		end
		if(@tSeq.nil? == true)
			MyTools.printfAndExit(1,"@tSeq is nil.",caller(0))
		end
		if(@tPeakList.nil? == true)
			MyTools.printfAndExit(1,"@tPeakList is nil.",caller(0))
		end
		if(@tComm.nil? == true)
			MyTools.printfAndExit(1,"@tComm is nil.",caller(0))
		end
#		if(@keyToJpostScore.nil? == true)
#			MyTools.printfAndExit(1,"@keyToJpostScore is nil.",caller(0))
#		end
		if(@ms2PeakSelectBin.nil? == true)
			MyTools.printfAndExit(1,"@ms2PeakSelectBin is nil.",caller(0))
		end
		if(@binRange.nil? == true)
			MyTools.printfAndExit(1,"@binRange is nil.",caller(0))
		end
		if(@plistMzNum.nil? == true)
			MyTools.printfAndExit(1,"@plistMzNum is nil.",caller(0))
		end
	end

	def ms2Match(
		aStdFalgAry,aMs2Flag,aMs2mzCenter,aMs2TolL,aMs2TolR,aMs2TolU)

		stdPt = 0
		rawPt = 0
		rtc = []

		while(true) do
			if(stdPt >= aStdFalgAry.length)
				break
			end
			if(rawPt >= aMs2Flag.length)
				break
			end

			(keyStr,stdMz) = aStdFalgAry[stdPt]
			(rawMz,rawInt,setNo,intParcent,maxNum) = aMs2Flag[rawPt]

			mzRangeL = SeqStrTools.getDiffDa(stdMz,aMs2TolL,aMs2TolU)
			mzRangeR = SeqStrTools.getDiffDa(stdMz,aMs2TolR,aMs2TolU)
			mzRangeCenter = SeqStrTools.getDiffDa(rawMz,aMs2mzCenter,aMs2TolU)
#p mzRangeL,mzRangeR,mzRangeCenter,rawMz,stdMz
#p aMs2mzCenter,mzRangeCenter
#exit(0)

			rawMz -= mzRangeCenter
			stdMzLow = stdMz - mzRangeL
			stdMzHeigh = stdMz + mzRangeR

			if(stdMzLow <= rawMz && rawMz <= stdMzHeigh)
#print  "match\n"

				diffValDa = rawMz - stdMz
#p diffVal
				if(SeqStrTools::PPM_STR == aMs2TolU)
					diffValConv = DisSRtools.getDiffPpm(rawMz,diffValDa)
				else
					diffValConv = diffValDa
				end

#p diffVal,aMs2TolU
#exit(0)

				rtc.push("#{keyStr}:#{setNo}:#{intParcent}:#{maxNum}")
				rawPt += 1
				stdPt += 1
				next
			end
#print  "unmatch\n"

			if(rawMz <= stdMz)
				rawPt += 1
			else
				stdPt += 1
			end
		end

		return rtc
	end

	def exec()
		self.check()

		flagObj = ImmoniumWeight.new()

		rtc = {}

		if(@keyToJpostScore == nil)
			scanNoKeyWk = @scanNoHit
		else
			scanNoKeyWk = @keyToJpostScore
		end

		stdMs2Flag = flagObj.getImmoniumIon("ACDEFGHIKMNPQRSTUVWY")
		stdMs2Flag = stdMs2Flag.sort_by{|k,v|v}


		scanNoKeyWk.each_key{|aKey|
			(scanNoWk,noUse,inFileNo,noUse,noUse,noUse,allItemAry,pepScoreWk,noUse) = @scanNoHit[aKey]

			if(@keyToJpostScore == nil)
				ms2mzCenter = 0.0
			else
				ms2mzCenter = @keyToJpostScore[aKey][1]
			end
#p ms2mzCenter
#exit(0)

			titleNoAry = @fileNoTitleAry[inFileNo]
			seqWk = DisSRtools.getItemData(titleNoAry,@tSeq,allItemAry)
			peakListWk = DisSRtools.getItemData(titleNoAry,@tPeakList,allItemAry)
			commWk = DisSRtools.getItemData(titleNoAry,@tComm,allItemAry)

			if(@ms2KeyType == DisSRconst::DSR_MS2_KEY_TITLE)
				ms2KeyWk = commWk
			else
				ms2KeyWk = scanNoWk
			end

#p aKey
#p titleNoAry
#p seqWk
#p peakListWk
#p commWk
#p ms2KeyWk
#exit(0)


			if(@ms2FlagAry[peakListWk] == nil)
				MyTools.printfAndExit(1,"@ms2FlagAry[#{peakListWk}] is nil.",caller(0))
			end
			if(@ms2FlagAry[peakListWk][ms2KeyWk] == nil)
				MyTools.printfAndExit(1,"@ms2FlagAry[#{peakListWk}][#{ms2KeyWk}] is nil.",caller(0))
			end

			(minMz,ms2FlagWk) = @ms2FlagAry[peakListWk][ms2KeyWk]
#p "a1"
#p peakListWk,ms2KeyWk
#p minMz,ms2FlagWk
#exit(0)

			if(@ms2PeakSelectBin == DisSRconst::DSR_MS2_M_BIN_MZ_Y)
				(ms2FlagWk,setNum,binNum,
				ms2MaxInt,ms2SumInt) = 
					DisSRtools.getTopItemBin(ms2FlagWk,minMz,@binRange,@plistMzNum,{})
			else
				(ms2FlagWk,setNum,
				ms2MaxInt,ms2SumInt) = 
					DisSRtools.getTopItem(ms2FlagWk,@plistMzNum)
			end
#p ms2FlagWk,setNum,binNum
#exit(0)


			ms2FlagWk.sort!{|a,b|
				a[0] <=> b[0]
			}

# HitしたSeqは使わない。2019.08.22 taba
#			stdMs2Flag = flagObj.getImmoniumIon(seqWk)
#			stdMs2Flag = stdMs2Flag.sort_by{|k,v|v}

			hitAry = self.ms2Match(
				stdMs2Flag,
				ms2FlagWk,
				ms2mzCenter,
				@ms2TolL,
				@ms2TolR,
				@ms2TolU
			)

			rtc[aKey] = hitAry
#p rtc
#exit(0)
		}
		return rtc
	end
end

=begin
-----------------------------------------------------------------------------
	ResultToCsvData

	入力のallTitleAryとscanNoHitとjpostScoreAryから
	結果出力用のCsvDataを作成する。

	作成日 2017-08-08 taba
-----------------------------------------------------------------------------
=end

class ResultToCsvData
	def initialize()
	end

	def setAllTitleAry(aVal)
		@allTitleAry = aVal
	end

	def setFileNoTitleAry(aVal)
		@fileNoTitleAry = aVal
	end

	def setScanNoHit(aVal)
		@scanNoHit = aVal
	end

	def setJpostScoreAry(aVal)
		@jpostScoreAry = aVal
	end

	def setImmoResAry(aVal)
		@immoResAry = aVal
	end

	def setMaxTagLen(aVal)
		@maxTagLen = aVal
	end

	def setPeptsURLparam(aVal)
		@peptUrlParam = aVal
	end

	def setMs2KeyType(aVal)
		@ms2KeyType = aVal
	end

	def check()
		if(@allTitleAry.nil? == true)
			MyTools.printfAndExit(1,"@allTitleAry is nil.",caller(0))
		end
		if(@fileNoTitleAry.nil? == true)
			MyTools.printfAndExit(1,"@fileNoTitleAry is nil.",caller(0))
		end
		if(@scanNoHit.nil? == true)
			MyTools.printfAndExit(1,"@scanNoHit is nil.",caller(0))
		end
		if(@jpostScoreAry.nil? == true)
			MyTools.printfAndExit(1,"@jpostScoreAry is nil.",caller(0))
		end
		if(@immoResAry.nil? == true)
			MyTools.printfAndExit(1,"@immoResAry is nil.",caller(0))
		end
		if(@maxTagLen.nil? == true)
			MyTools.printfAndExit(1,"@maxTagLen is nil.",caller(0))
		end
		if(@peptUrlParam.nil? == true)
			MyTools.printfAndExit(1,"@peptUrlParam is nil.",caller(0))
		end
		if(@ms2KeyType.nil? == true)
			MyTools.printfAndExit(1,"@ms2KeyType is nil.",caller(0))
		end
	end

	def setItemData(aRtc,aSetNo,aTitleAry,aAllItemAry)
		aTitleAry.each{|aTitleStr,aPointNum|
			aRtc[aTitleStr][aSetNo] = aAllItemAry[aPointNum]
		}
	end

	def getHitCountStr(aHitCountAry)
		rtc = []
		aHitCountAry.each{|aKey,aVal|
			rtc.push("#{aKey}/#{aVal}")
		}
		return rtc.join(',')
	end

	def getAllFlagStr(aAllFlagToMatch)
		rtcKeyAry = []
		rtcValAry = []
		aAllFlagToMatch.each{|aKey,aVal|
			rtcKeyAry.push(aKey)
			if(aVal == true)
				rtcValAry.push('M')
			else
				rtcValAry.push('u')
			end
		}
		return [rtcKeyAry.join(','),rtcValAry.join('')]
	end

	def getUpdateUrl(
		aNowUrl,aPeptUrlParam,aCancelFragNo,aIsMs2KeyScan,aMs2mzCenter)

		(addrWk,paraStr) = aNowUrl.split('?',2)
		if(paraStr == nil)
			p aNowUrl
			MyTools.printfAndExit(1,"aNowUrl is mistake.",caller(0))
		end
		paraItemAry = paraStr.split('&')
		paramAryWk = {}
		paraItemAry.each{|aItem|
			(paraKey,valWk) = aItem.split('=',2)
			if(valWk == nil)
				valWk = ''
			end
			paramAryWk[paraKey] = valWk
		}
#p aNowUrl
#p addrWk,paraStr
#p paramAryWk
#exit(0)

		aPeptUrlParam.each{|aKey,aVal|
			paramAryWk[aKey] = aVal
		}
		paramAryWk[PepHitConst::GET_CANCEL_FRAG_NO] = aCancelFragNo
		paramAryWk[PepHitConst::GET_IS_MS2_KEY_SCAN] = aIsMs2KeyScan
		paramAryWk[PepHitConst::GET_MS2_MZ_CENTER] = sprintf("%.5f",aMs2mzCenter)

		wkAry = []
		paramAryWk.each{|aKey,aVal|
			wkAry.push("#{aKey}=#{aVal}")
		}
#p paramAryWk
#p "#{addrWk}?" + wkAry.join('&')
#exit(0)

		return "#{addrWk}?" + wkAry.join('&')
	end

	def exec()
		self.check()

		rtc = {}

		addTitle = [
			ReqFileType::CSV_SCAN_NO,
			ReqFileType::CSV_PL_HIT_COUNT,
			ReqFileType::CSV_ENG_HIT_COUNT,
			ReqFileType::CSV_PL_ENG_HIT_SCORE,
			ReqFileType::CSV_JPOST_SCORE,
			ReqFileType::CSV_M_FLAG_DETAIL,
			ReqFileType::CSV_M_IMMO_DETAIL,
			ReqFileType::CSV_M_FLAG_COUNT,
			ReqFileType::CSV_UM_FLAG_COUNT,
			ReqFileType::CSV_HIT_PART_SEQ,
			ReqFileType::CSV_M_FLAG_INT_P,
			ReqFileType::CSV_M_FLAG_INT_SUM,
			ReqFileType::CSV_MS2_TOL_DIFF_MZ,
			ReqFileType::CSV_MS2_P_INFO,
			ReqFileType::CSV_HIT_AMINO_PT,
			ReqFileType::CSV_FLAG_THO_SER,
			ReqFileType::CSV_FLAG_MATCH_INFO,
			ReqFileType::CSV_SCORE_MASCOT,
			ReqFileType::CSV_SCORE_TANDEM,
			ReqFileType::CSV_SCORE_MAXQUANT,
			ReqFileType::CSV_SCORE_COMET,
			ReqFileType::CSV_SCORE_COMET_SP,
			ReqFileType::CSV_SCORE_PILOT,
			ReqFileType::CSV_SCORE_MSFRG,
			ReqFileType::CSV_B_HIT_ION_SUM,
			ReqFileType::CSV_S_HIT_ION_SUM,
			ReqFileType::CSV_B_NO_HIT_ION_SUM,
			ReqFileType::CSV_HIT_TAG_LEN_JOINT,
			ReqFileType::CSV_NO_HIT_TAG_LEN_JOINT,
		]

		allTitleAryWk = @allTitleAry.clone()
		allTitleAryWk.delete(ReqFileType::CSV_SCORE_COMET_SP)

		wkAry = allTitleAryWk + addTitle

		maxTagLenTitle = ReqFileType::CSV_MAX_TAG_LEN
		tagLenTitle = ReqFileType::CSV_TAG_LEN_TITLE
#		tagKindAry = ['b','y','b+y']
		tagKindAry = ['b+y']

		wkAry.push(maxTagLenTitle)
		tagKindAry.each{|aTagKind|
			1.upto(@maxTagLen){|i|
				wkAry.push("#{aTagKind}#{tagLenTitle}#{i}")
			}
		}

		wkAry.each{|aTitleStr|
			rtc[aTitleStr] = []
		}
		wkAry = nil
		addTitle = nil

		isMs2KeyScan = true
		if(@ms2KeyType == DisSRconst::DSR_MS2_KEY_TITLE)
			isMs2KeyScan = false
		end

		setNo = 0

		@scanNoHit.each_key{|aKey|
			(scanNoWk,noUse1,inFileNo,plEngAry,plAry,engAry,allItemAry,pepScoreWk,engScoreWk) = @scanNoHit[aKey]

			if(@jpostScoreAry[aKey] == nil)
				next
			end

			if(@immoResAry[aKey] == nil)
				p aKey
				MyTools.printfAndExit(1,"@immoResAry is nil.",caller(0))
			end

			(rtcHitFlagPt,rtcJpostScore,rtcHitPartSeq,rtcHitNum,rtcHitDiff,rtcMaxSeries,rtcSeriesCount,rtcHitNumStr,rtcHitFlagStr,rtcHitFlagChg,rtcHitFlagKind,rtcHitFlagHash,rtcMatchFlagDetail,rtcMatchFlagIntNo,rtcMatchFlagIntPar,rtcMatchFlagTop10,rtcMatchFlagLow5,rtcMs2IntMax,rtcMs2IntSum,rtcMatchFlagCount,rtcMatchAmiPt,allFlagToMatch,allTagLenCount,rtcMaxTagLen,rtcCancelFragNo,ms2mzCenter,rtcBothMatchSum,rtcSingleMatchSum,rtcBothUnMatchSum,allTagHitWk,allTagNoHitWk,ms2FlagSetNum,rtcMs2Info) = @jpostScoreAry[aKey]

#p ms2mzCenter
#exit(0)
			matchImmoDetail = @immoResAry[aKey]

			titleAry = @fileNoTitleAry[inFileNo]

			self.setItemData(rtc,setNo,titleAry,allItemAry)

			(flagStr,matchStr) = self.getAllFlagStr(allFlagToMatch)

			rtc[ReqFileType::CSV_NO][setNo] = setNo + 1
			rtc[ReqFileType::CSV_SCAN_NO][setNo] = scanNoWk
			rtc[ReqFileType::CSV_PL_HIT_COUNT][setNo] = self.getHitCountStr(plAry)
			rtc[ReqFileType::CSV_ENG_HIT_COUNT][setNo] = self.getHitCountStr(engAry)
			rtc[ReqFileType::CSV_PL_ENG_HIT_SCORE][setNo] = plEngAry.join(',')


			rtc[ReqFileType::CSV_JPOST_SCORE][setNo] = rtcJpostScore
			rtc[ReqFileType::CSV_M_FLAG_DETAIL][setNo] = rtcMatchFlagDetail
			rtc[ReqFileType::CSV_M_IMMO_DETAIL][setNo] = matchImmoDetail.join(',')
			rtc[ReqFileType::CSV_M_FLAG_COUNT][setNo] = rtcMatchFlagCount
			rtc[ReqFileType::CSV_UM_FLAG_COUNT][setNo] = ms2FlagSetNum - rtcMatchFlagCount
			rtc[ReqFileType::CSV_HIT_PART_SEQ][setNo] = rtcHitPartSeq
			rtc[ReqFileType::CSV_M_FLAG_INT_P][setNo] = rtcMatchFlagIntPar
			rtc[ReqFileType::CSV_M_FLAG_INT_SUM][setNo] = rtcMs2IntSum
			rtc[ReqFileType::CSV_MS2_TOL_DIFF_MZ][setNo] = JSON.generate(rtcHitDiff)
			rtc[ReqFileType::CSV_B_HIT_ION_SUM][setNo] = rtcBothMatchSum
			rtc[ReqFileType::CSV_S_HIT_ION_SUM][setNo] = rtcSingleMatchSum
			rtc[ReqFileType::CSV_B_NO_HIT_ION_SUM][setNo] = rtcBothUnMatchSum
			rtc[ReqFileType::CSV_HIT_TAG_LEN_JOINT][setNo] = allTagHitWk.join(',')
			rtc[ReqFileType::CSV_NO_HIT_TAG_LEN_JOINT][setNo] = allTagNoHitWk.join(',')
			rtc[ReqFileType::CSV_HIT_AMINO_PT][setNo] = rtcMatchAmiPt.join(',')
			rtc[ReqFileType::CSV_FLAG_THO_SER][setNo] = flagStr
			rtc[ReqFileType::CSV_FLAG_MATCH_INFO][setNo] = matchStr
			rtc[ReqFileType::CSV_MS2_P_INFO][setNo] = rtcMs2Info.join(':')

			cancelFragNo = rtcCancelFragNo.keys()
			cancelFragNo = cancelFragNo.join(',')
#p cancelFragNo

			if(rtc[ReqFileType::CSV_SEARCH_ENGINE][setNo] != Pconst::S_ENG_MASCOT)
				nowUrl = rtc[ReqFileType::CSV_PEPTS_URL][setNo]
				updateUrl = self.getUpdateUrl(nowUrl,@peptUrlParam,cancelFragNo,isMs2KeyScan,ms2mzCenter)
				rtc[ReqFileType::CSV_PEPTS_URL][setNo] = updateUrl
			end

			nowUrl = rtc[ReqFileType::CSV_PEPTS_URL_LORIKEET][setNo]
			updateUrl = self.getUpdateUrl(nowUrl,@peptUrlParam,cancelFragNo,isMs2KeyScan,ms2mzCenter)
			rtc[ReqFileType::CSV_PEPTS_URL_LORIKEET][setNo] = updateUrl

			engScoreWk.each{|aKey,aVal|
				rtc[aKey][setNo] = aVal
			}
			rtc[maxTagLenTitle][setNo] = rtcMaxTagLen

			allTagLenCount.each{|aTagKind,aTagLenAry|
				1.upto(@maxTagLen){|i|
					titleWk = "#{aTagKind}#{tagLenTitle}#{i}"
					if(aTagLenAry[i] == nil)
						rtc[titleWk][setNo] = 0
					else
						rtc[titleWk][setNo] = aTagLenAry[i]
					end
				}
			}

#p rtc
#exit(0)

			setNo += 1
		}
		return rtc
	end
end
