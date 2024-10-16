#
# Copyright (c) 2012 Eisai Co., Ltd. All rights reserved.
#

=begin
//----------------------------------------------------------------------------
//	class SeqStrTools
//
//	アミノ酸配列を操作する関数群。
//	オリジナルはCalssSeqTools0.07.phpの class SeqStrTools
//
//	作成日2016-12-14 taba
//----------------------------------------------------------------------------
=end

class SeqStrTools
	C_TERM = 'C-term'
	N_TERM = 'N-term'
	PPM_STR = 'ppm'

	def SeqStrTools.arrayJoint(aFromAry,aToAry)
		rtc = []
		aFromAry.each{|aFromStr|
			aToAry.each{|aToStr|
				rtc.push(aFromStr + aToStr)
			}
		}
		return rtc
	end

	def SeqStrTools.getDiffDa(aSampleDa,aTol,aTolU)
		if(PPM_STR == aTolU)
			rtc = aSampleDa * aTol / 1000000
		else
			rtc = aTol
		end
		return rtc
	end

	def SeqStrTools.cutSeq(aSeq,aCutStr,aTerm)
		if(aSeq.length <= 0)
			p aSeq
			MyTools.printfAndExit(1,"aSeq is null.",caller(0))
		end
		if(aCutStr.length <= 0)
			p aSeq
			MyTools.printfAndExit(1,"aCutStr is null.",caller(0))
		end
		if(aTerm.length <= 0)
			p aSeq
			MyTools.printfAndExit(1,"aTerm is null.",caller(0))
		end

		rtc = []

		aCutStr = aCutStr.gsub("B","DN")
		aCutStr = aCutStr.gsub("Z","EQ")

		pepWk = ''
		for i in 0...aSeq.length
			seqCh = aSeq[i]
			if(aCutStr.index(seqCh) == nil)
				pepWk += seqCh
				next
			end
			if(aTerm == C_TERM)
				pepWk += seqCh
			end

			if(pepWk != '')
				rtc.push(pepWk)
			end

			if(aTerm == C_TERM)
				pepWk = ''
			else
				pepWk = seqCh
			end
		end
		if(pepWk != '')
			rtc.push(pepWk)
		end

		return rtc
	end

	def SeqStrTools.restrictSeq(aPepAry,aResStr,aTerm)
		if(aResStr.length <= 0)
			return aPepAry
		end
		if(aTerm == C_TERM)
			rrPoint = 0
		else
			rrPoint = 1
		end

		rtc = []

		resLen = aResStr.length
		pepWk = aPepAry[0]

		for i in 1...aPepAry.length
			nowPep = aPepAry[i]
			chkStr = nowPep[rrPoint,resLen]
			if(chkStr == aResStr)
				pepWk += nowPep
			else
				rtc.push(pepWk)
				pepWk = nowPep
			end

		end
		rtc.push(pepWk)

		return rtc
	end

	def SeqStrTools.missCleavageSeq(aPepAry,aMissNo)
		if(aMissNo <= 0)
			p aMissNo
			MyTools.printfAndExit(1,"aMissNo is null.",caller(0))
		end

		rtc = []

		for i in 0...(aPepAry.length - aMissNo)
			pepWk = aPepAry[i]
			for j in 1..aMissNo
				pepWk += aPepAry[i+j]
			end
			rtc.push(pepWk)
		end

		return rtc
	end

	def SeqStrTools.extSeqConv(aPepSeq,aMultiAmi=false)
		convAryNoMutli = {
			'B' => ['D','N'],
			'Z' => ['E','Q'],
			'X' => ['A','C','D','E','F','G','H','I','K','L',
				'M','N','P','Q','R','S','T','V','W','Y']
		}
		convAryMulti = {
			'B' => ['D','N','B'],
			'Z' => ['E','Q','Z'],
			'X' => ['A','C','D','E','F','G','H','I','K','L',
				'M','N','P','Q','R','S','T','V','W','Y','X']
		}

		if(aMultiAmi == false)
			convAry = convAryNoMutli
		else
			convAry = convAryMulti
		end

		rtc = [aPepSeq]

		convAry.each{|aKey,aAmiAry|
			grpAry = []

			rtc.each{|aTargetSeq|
				cutAry = aTargetSeq.split(aKey)
				if(cutAry.length <= 1)
					if(cutAry[0] == aTargetSeq)
						grpAry = rtc
						break
					end
					cutAry.push('')
				end
				wkAry = [cutAry[0]]
				j = 0
				while(true) do
					if(cutAry[j+1] == nil)
						break
					end
					wkAry = SeqStrTools.arrayJoint(wkAry,aAmiAry)
					j += 1
					wkAry = SeqStrTools.arrayJoint(wkAry,[cutAry[j]])
				end

				grpAry += wkAry

			}
			rtc = grpAry
		}

		return rtc
	end
end

=begin
//----------------------------------------------------------------------------
//	class ChemWeight
//
//	元素記号の重量を求める。
//
//	作成日2012-08-08 taba
//----------------------------------------------------------------------------
=end

class ChemWeight
	MONO_MASS_PT = 0
	AVG_MASS_PT = 1

	def initialize()
# http://www.nist.gov/pml/div684/fcdc/upload/chart.pdf
# http://www.nist.gov/pml/div684/fcdc/codata.cfm
# 2011-08-04 modify taba

		@versionInfo = '2011-08-04 modified.'

		@electWei = [0.0005485799,0.0005485799]

# http://physics.nist.gov/cgi-bin/Compositions/stand_alone.pl?ele=&ascii=html&isotype=some
# http://www.ciaaw.org/index.htm
# 2011-08-04 modify taba

		@chemWei = {
			"H" => [1.00782503207,1.00794],
			"O" => [15.99491461956,15.9994],
			"N" => [14.0030740048,14.0067],
			"C" => [12.0,12.0107],
			"S" => [31.97207100,32.065],
			"P" => [30.97376163,30.973762],
			"Se"=> [79.9165213,78.96],
			"Na"=> [22.9897692809, 22.98976928],
			"Cl"=> [34.96885272, 35.453],	# 2019-01-22 add taba
			"K"=> [38.9637074, 39.0983],	# 2019-01-22 add taba
			"F"=> [18.99840322, 18.9984032],	# 2019-01-22 add taba
			"I"=> [126.904473, 126.90447],	# 2019-01-22 add taba
			"Br"=> [78.9183361, 79.904],	# 2019-01-22 add taba
			"Hg"=> [201.970617, 200.59],	# 2019-01-22 add taba
			"Cu"=> [62.9295989, 63.546],	# 2019-01-22 add taba
			"Fe"=> [55.9349393, 55.845],	# 2019-01-22 add taba
			"Mo"=> [97.9054073, 95.94],	# 2019-01-22 add taba
			"B"=> [11.0093055, 10.811],	# 2019-01-22 add taba
			"As"=> [74.9215942, 74.9215942],	# 2019-01-22 add taba
			"Li"=> [7.016003, 6.941],	# 2019-01-22 add taba
			"Ca"=> [39.9625906, 40.078],	# 2019-01-22 add taba
			"Ni"=> [57.9353462, 58.6934],	# 2019-01-22 add taba
			"Zn"=> [63.9291448, 65.409],	# 2019-01-22 add taba
			"Ag"=> [106.905092, 107.8682],	# 2019-01-22 add taba
			"Mg"=> [23.9850423, 24.305],	# 2019-01-22 add taba
		}

		@isoWei = {
			"H"   => 1.00782503207,
			"2H"   => 2.0141017778,
			"D"   => 2.0141017778,
			"12C" => 12.0,
			"13C" => 13.0033548378,
			"14N" => 14.0030740048,
			"15N" => 15.0001088982,
			"16O" => 15.99491461956,
			"17O" => 16.99913170,
			"18O" => 17.9991610,
			"33S" => 32.97145876,
			"34S" => 33.96786690,
			"36S" => 35.96708076,
		}
	end

	def getIsoWeight(chemStr)
		if(@isoWei[chemStr].nil? == true)
			MyTools.printfAndExit(1,"@isoWei[#{chemStr}] is null.",caller(0))
		end
		return @isoWei[chemStr]
	end

	def calChemWeight(
		chemStr,massKind=ChemWeight::MONO_MASS_PT)
		wei = 0.0
		chemLen = chemStr.length
		countNumeric = 0
		constVal = 1
		chrmSign = ''
		(chemLen-1).downto(0){|i|
			readChrmSign = chemStr[i]
			chrmSign = readChrmSign + chrmSign;
			if(readChrmSign != readChrmSign.upcase())
				next
			end
			if(chrmSign == '-')
				constVal *= -1
				chrmSign = ''
				next
			end
			if(MyTools.is_numeric(chrmSign) == true)
				if(countNumeric == 0)
					constVal = chrmSign.to_i()
				else
					constVal += chrmSign.to_i() * (10 ** countNumeric)
				end
#print "constVal=#{constVal},countNumeric=#{countNumeric}\n"
				chrmSign = ''
				countNumeric += 1
				next
			end
			if(@chemWei[chrmSign].nil? == true)
				MyTools.printfAndExit(1,"@chemWei[#{chrmSign}] is null.",caller(0))
			end
#print "constVal=$constVal\n";
			wei += @chemWei[chrmSign][massKind] * constVal
#var_dump($wei);
			countNumeric = 0
			constVal = 1
			chrmSign = ''
		}
		return wei;
	end

	def getChemCount(chemStr)
		rtc = {}
		chemLen = chemStr.length
		countNumeric = 0
		constVal = 1
		chrmSign = ''
		(chemLen-1).downto(0){|i|
			readChrmSign = chemStr[i]
			chrmSign = readChrmSign + chrmSign;
			if(readChrmSign != readChrmSign.upcase())
				next
			end
			if(chrmSign == '-')
				constVal *= -1
				chrmSign = ''
				next
			end
			if(MyTools.is_numeric(chrmSign) == true)
				if(countNumeric == 0)
					constVal = chrmSign.to_i()
				else
					constVal += chrmSign.to_i() * (10 ** countNumeric)
				end
#print "constVal=#{constVal},countNumeric=#{countNumeric}\n"
				chrmSign = ''
				countNumeric += 1
				next
			end
			if(@chemWei[chrmSign].nil? == true)
				p chemStr
				MyTools.printfAndExit(1,"@chemWei[#{chrmSign}] is null.",caller(0))
			end
#print "constVal=$constVal\n";
			if(rtc[chrmSign] == nil)
				rtc[chrmSign] = constVal
			else
				rtc[chrmSign] += constVal
			end
			countNumeric = 0
			constVal = 1
			chrmSign = ''
		}
		return rtc;
	end

	def getElectWeight(massKind=ChemWeight::MONO_MASS_PT)
		if(@electWei[massKind].nil? == true)
			MyTools.printfAndExit(1,"@electWei[#{massKind}] is nill.",caller(0))
		end
		return @electWei[massKind]
	end
end

=begin
//----------------------------------------------------------------------------
//	class PepWeight
//
//	アミノ酸配列の重量を求める。
//	オリジナルはProtein5.A4の class PepWeight
//
//	作成日2012-08-08 taba
//----------------------------------------------------------------------------
=end

class PepWeight
	MONO_MASS_PT = 0
	AVG_MASS_PT = 1

	NTERM_STR = "N-TERM"
	CTERM_STR = "C-TERM"

	def initialize()
		@chemWeiObj = ChemWeight.new()

		@aminoWei = {
			"A" => [	# 71.0371137847,71.0779
	@chemWeiObj.calChemWeight('C3H5NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C3H5NO',ChemWeight::AVG_MASS_PT),
			],

			"B" => [	# 114.534935232,114.59502 D,N-amino-avg
	@chemWeiObj.calChemWeight('C4H5NO3'+'C4H6N2O2',ChemWeight::MONO_MASS_PT)/2,
	@chemWeiObj.calChemWeight('C4H5NO3'+'C4H6N2O2',ChemWeight::AVG_MASS_PT)/2,
			],

			"C" => [	# 103.009184785,103.1429
	@chemWeiObj.calChemWeight('C3H5NOS',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C3H5NOS',ChemWeight::AVG_MASS_PT),
			],

			"D" => [	# 115.026943024,115.0874
	@chemWeiObj.calChemWeight('C4H5NO3',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C4H5NO3',ChemWeight::AVG_MASS_PT),
			],

			"E" => [	# 129.042593088,129.11398
	@chemWeiObj.calChemWeight('C5H7NO3',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C5H7NO3',ChemWeight::AVG_MASS_PT),
			],

			"F" => [	# 147.068413913,147.17386
	@chemWeiObj.calChemWeight('C9H9NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C9H9NO',ChemWeight::AVG_MASS_PT),
			],

			"G" => [	# 57.0214637206,57.05132
	@chemWeiObj.calChemWeight('C2H3NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C2H3NO',ChemWeight::AVG_MASS_PT),
			],

			"H" => [	# 137.058911858,137.13928
	@chemWeiObj.calChemWeight('C6H7N3O',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C6H7N3O',ChemWeight::AVG_MASS_PT),
			],

			"I" => [	# 113.084063977,113.15764
	@chemWeiObj.calChemWeight('C6H11NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C6H11NO',ChemWeight::AVG_MASS_PT),
			],

			"J" => [0,0],

			"K" => [	# 128.094963014,128.17228
	@chemWeiObj.calChemWeight('C6H12N2O',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C6H12N2O',ChemWeight::AVG_MASS_PT),
			],

			"L" => [	# 113.084063977,113.15764
	@chemWeiObj.calChemWeight('C6H11NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C6H11NO',ChemWeight::AVG_MASS_PT),
			],

			"M" => [	# 131.040484913,131.19606
	@chemWeiObj.calChemWeight('C5H9NOS',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C5H9NOS',ChemWeight::AVG_MASS_PT),
			],

			"N" => [	# 114.042927441,114.10264
	@chemWeiObj.calChemWeight('C4H6N2O2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C4H6N2O2',ChemWeight::AVG_MASS_PT),
			],

			"O" => [0,0],

			"P" => [	# 97.0527638488,97.11518
	@chemWeiObj.calChemWeight('C5H7NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C5H7NO',ChemWeight::AVG_MASS_PT),
			],

			"Q" => [	# 128.058577505,128.12922
	@chemWeiObj.calChemWeight('C5H8N2O2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C5H8N2O2',ChemWeight::AVG_MASS_PT),
			],

			"R" => [	# 156.101111024,156.18568
	@chemWeiObj.calChemWeight('C6H12N4O',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C6H12N4O',ChemWeight::AVG_MASS_PT),
			],

			"S" => [	# 87.0320284043,87.0773
	@chemWeiObj.calChemWeight('C3H5NO2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C3H5NO2',ChemWeight::AVG_MASS_PT),
			],

			"T" => [	# 101.047678468,101.10388
	@chemWeiObj.calChemWeight('C4H7NO2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C4H7NO2',ChemWeight::AVG_MASS_PT),
			],

			"U" => [	#150.953635085,150.0379 Selenocysteine
	@chemWeiObj.calChemWeight('C3H5NOSe',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C3H5NOSe',ChemWeight::AVG_MASS_PT),
			],

			"V" => [	# 99.068413913,99.13106
	@chemWeiObj.calChemWeight('C5H9NO',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C5H9NO',ChemWeight::AVG_MASS_PT),
			],

			"W" => [	# 186.07931295,186.2099
	@chemWeiObj.calChemWeight('C11H10N2O',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C11H10N2O',ChemWeight::AVG_MASS_PT),
			],

			"X" => [111.060000,111.060000], # all-amino-avg

			"Y" => [	# 163.063328533,163.17326
	@chemWeiObj.calChemWeight('C9H9NO2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('C9H9NO2',ChemWeight::AVG_MASS_PT),
			],

			"Z" => [	# 128.550585297,128.6216 E,Q-amino-avg
	@chemWeiObj.calChemWeight('C5H7NO3'+'C5H8N2O2',ChemWeight::MONO_MASS_PT)/2,
	@chemWeiObj.calChemWeight('C5H7NO3'+'C5H8N2O2',ChemWeight::AVG_MASS_PT)/2,
			],

			PepWeight::NTERM_STR => [
	@chemWeiObj.calChemWeight('H',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('H',ChemWeight::AVG_MASS_PT),
			],

			PepWeight::CTERM_STR => [
	@chemWeiObj.calChemWeight('OH',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('OH',ChemWeight::AVG_MASS_PT),
			],
		}

	end

	def getAminoWeight(key,massKind=PepWeight::MONO_MASS_PT)
		keyWk = key.upcase()
		if(@aminoWei[keyWk][massKind] == nil)
			MyTools.printfAndExit(1,"@aminoWei[#{keyWk}] is nill.",caller(0))
		end
		return @aminoWei[keyWk][massKind]
	end

	def calFlagWeight(seq,massKind=PepWeight::MONO_MASS_PT)
		rtc = 0.0
		seqLen = seq.length - 1
		0.upto(seqLen){|i|
			rtc += self.getAminoWeight(seq[i],massKind)
		}
		return rtc
	end

	def calPepWeight(seq,massKind=PepWeight::MONO_MASS_PT)
		return self.calFlagWeight(seq,massKind) + 
			self.getAminoWeight(PepWeight::NTERM_STR,massKind) + 
			self.getAminoWeight(PepWeight::CTERM_STR,massKind);
	end

	def calIonWeight(dalton,charge,massKind=PepWeight::MONO_MASS_PT)
		return (dalton + (charge * @chemWeiObj.calChemWeight('H',massKind)) - (charge * @chemWeiObj.getElectWeight(massKind))) / charge.abs()
	end

	def calMassWeight(mz,charge,massKind=PepWeight::MONO_MASS_PT)
		return mz * charge.abs() - (charge * @chemWeiObj.calChemWeight('H',massKind)) + (charge * @chemWeiObj.getElectWeight(massKind))
	end

end

=begin
//----------------------------------------------------------------------------
//	class MS2FlagWeight
//
//	MS2のフラグメントの重量を求める。
//
//	作成日2016-03-01 taba
//----------------------------------------------------------------------------
=end

class MS2FlagWeight

	ION_A = "a"
	ION_B = "b"
	ION_C = "c"
	ION_X = "x"
	ION_Y = "y"
	ION_Z = "z"

	def initialize()
		@chemWeiObj = ChemWeight.new()

		@delta = {
			ION_A => [
	-@chemWeiObj.calChemWeight('CO',ChemWeight::MONO_MASS_PT),
	-@chemWeiObj.calChemWeight('CO',ChemWeight::AVG_MASS_PT),
				PepWeight::NTERM_STR,
			],
			ION_B => [
				0.0,
				0.0,
				PepWeight::NTERM_STR,
			],
			ION_C => [
	@chemWeiObj.calChemWeight('NH3',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('NH3',ChemWeight::AVG_MASS_PT),
				PepWeight::NTERM_STR,
			],
			ION_X => [
	@chemWeiObj.calChemWeight('CO2',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('CO2',ChemWeight::AVG_MASS_PT),
				PepWeight::CTERM_STR,
			],
			ION_Y => [
	@chemWeiObj.calChemWeight('H2O',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('H2O',ChemWeight::AVG_MASS_PT),
				PepWeight::CTERM_STR,
			],
			ION_Z => [
	@chemWeiObj.calChemWeight('O',ChemWeight::MONO_MASS_PT) - @chemWeiObj.calChemWeight('N',ChemWeight::MONO_MASS_PT),
	@chemWeiObj.calChemWeight('O',ChemWeight::AVG_MASS_PT) - @chemWeiObj.calChemWeight('N',ChemWeight::AVG_MASS_PT),
				PepWeight::CTERM_STR,
			],

		}
	end

	def convModAry(aModDetail)
		rtc = {}

		if(aModDetail == nil)
			return rtc
		end

		modAry = aModDetail.split(',')
		modAry.each{|aModItemAry|
			(weight,modAmi,motPt) = aModItemAry.split(/@|:/)
			if(motPt == nil)
				p aModDetail
				MyTools.printfAndExit(1,"aModDetail is mistake.",caller(0))
			end
			modPtWk = motPt.to_i()
			if(rtc[modPtWk] == nil)
				rtc[modPtWk] = weight.to_f()
			else
				rtc[modPtWk] += weight.to_f()
			end
		}
		return rtc
	end

	def convNLmodAry(aModDetail,aSeqLen,aNLAry,aRejectAmi)
		rtcN = {}
		wkCterm = []

		if(aModDetail == nil)
			return [{},{}]
		end

		(nlWeiKey,nlKey,diffWei) = aNLAry

		modAry = aModDetail.split(',')
		modAry.each{|aModItemAry|
			(weight,modAmi,modPt) = aModItemAry.split(/@|:/)
			if(modPt == nil)
				p aModDetail
				MyTools.printfAndExit(1,"aModDetail is mistake.",caller(0))
			end
			if(weight != nlWeiKey)
				next
			end
			if(aRejectAmi[modAmi] != nil)
				next
			end
			diffWeiFloat = diffWei.to_f()
			modPtInt = modPt.to_i()
			modPtCterm = aSeqLen - modPtInt + 1
			wkCterm.push([modPtCterm,nlKey,diffWeiFloat])
			rtcN[modPtInt] = [nlKey,diffWeiFloat]
		}

		sortedWk = wkCterm.sort{|a,b|
			a[0] <=> b[0]
		}
#p aModDetail,wkCterm,sortedWk,rtcN
#exit(0)

		rtcC = {}
		sortedWk.each{|aItemWk|
			(modPt,nlKey,diffWei) = aItemWk
			rtcC[modPt] = [nlKey,diffWei]
		}

		return [rtcN,rtcC]
	end

	def getAllFlagment(aSeq,aChargeAry,aModAry,aMassKind=ChemWeight::MONO_MASS_PT)
		pepObj = PepWeight.new()

		sumMod = 0.0
		aModAry.each{|aKey,aVal|
			sumMod += aVal
		}

		ntermWk = 0.0
		ctermWk = pepObj.calFlagWeight(aSeq,aMassKind) + sumMod
		oldAminoWei = 0.0
		rtc = {}

#p ntermWk,ctermWk
#exit(0)


		for i in 1..aSeq.length do
			aminoWk = pepObj.getAminoWeight(aSeq[i-1],aMassKind)
#p aminoWk
#exit(0)
			if(i <= 1 && aModAry[0] != nil)
				aminoWk += aModAry[0]
			elsif(i >= aSeq.length && aModAry[i+1] != nil)
				aminoWk += aModAry[i+1]
			end
			if(aModAry[i] != nil)
				aminoWk += aModAry[i]
			end
			ntermWk += aminoWk
			ctermWk -= oldAminoWei
#p ntermWk,ctermWk
#exit(0)

			@delta.each{|aIonKey,aValAry|
				diffVal = aValAry[aMassKind]
				termVal = aValAry[2]
				if(termVal == PepWeight::NTERM_STR)
					flagNo = i
					weightWk = ntermWk + diffVal
				else
					flagNo = aSeq.length - i + 1
					weightWk = ctermWk + diffVal
				end
				if(flagNo >= aSeq.length)
					next
				end
				aChargeAry.each{|aChgVal|
					if(rtc[aIonKey] == nil)
						rtc[aIonKey] = {}
					end
					if(rtc[aIonKey][aChgVal] == nil)
						rtc[aIonKey][aChgVal] = {}
					end
					rtc[aIonKey][aChgVal][flagNo] = pepObj.calIonWeight(weightWk,aChgVal,aMassKind)
				}
			}

			oldAminoWei = aminoWk
		end
		return rtc
	end

	def getNLallFlagment(rtc,aBaseWeiAry,aDiffLosAry,aTermStr)
		beforeNlKey = nil
		nlNum = 1
		pepObj = PepWeight.new()

		aDiffLosAry.each{|aModPt,aModAry|

			(nlKey,diffWei) = aModAry
			nlKeyStr = nlKey * nlNum
#p nlKeyStr,beforeNlKey

			if(beforeNlKey == nil)
				ionAry = aBaseWeiAry
			else
				ionAry = rtc[beforeNlKey]
			end

			ionAry.each{|aIonKey,aChgAry|

				(noUse,noUse,termStr) = @delta[aIonKey]

				aChgAry.each{|aChgVal,aFlagAry|

					aFlagAry.each{|aFlagNo,aWeight|

						if(termStr != aTermStr)
							next
						end

						if(aFlagNo < aModPt)
							next
						end

						if(rtc[nlKeyStr] == nil)
							rtc[nlKeyStr] = {}
						end
						if(rtc[nlKeyStr][aIonKey] == nil)
							rtc[nlKeyStr][aIonKey] = {}
						end
						if(rtc[nlKeyStr][aIonKey][aChgVal] == nil)
							rtc[nlKeyStr][aIonKey][aChgVal] = {}
						end

						rtc[nlKeyStr][aIonKey][aChgVal][aFlagNo] = aWeight - (diffWei / aChgVal.abs())
					}
				}
			}
			nlNum += 1
			beforeNlKey = nlKeyStr
		}
	end
end

=begin
//----------------------------------------------------------------------------
//	class ImmoniumWeight
//
//	Immoniumイオンの重量を求める。
//
//	作成日2019-08-20 taba
//----------------------------------------------------------------------------
=end

class ImmoniumWeight
#	IMMO_KEY = 'Immo-'
	IMMO_KEY = ''

	def initialize()
		@pepObj = PepWeight.new()
		@chemWeiObj = ChemWeight.new()
		@immoWei = []
	end

	def getImmoniumIon(aSeqStr,aMassKind=ChemWeight::MONO_MASS_PT)
		rtc = {}
		seqLen = aSeqStr.length - 1
		0.upto(seqLen){|i|
			seqChr = aSeqStr[i]
			keyStr = "#{IMMO_KEY}#{seqChr}"
			if(@immoWei[aMassKind] == nil)
				@immoWei[aMassKind] = {}
			end
			if(@immoWei[aMassKind][seqChr] == nil)
				diffWei = @chemWeiObj.calChemWeight('H',aMassKind) - @chemWeiObj.calChemWeight('CO',aMassKind)
				@immoWei[aMassKind][seqChr] = @pepObj.calFlagWeight(seqChr,aMassKind) + diffWei
			end
			rtc[keyStr] = @immoWei[aMassKind][seqChr]
		}
#p @immoWei
		return rtc
	end
end
