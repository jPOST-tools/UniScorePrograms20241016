# encoding: utf-8
#
# Copyright (c) 2017 Department of Molecular and Cellular Bioanalysis,
# Graduate School of Pharmaceutical Sciences,
# Kyoto University. All rights reserved.
#

=begin
-----------------------------------------------------------------------------
	GetParamData.rb

	DistinctSearchResultで使用するパラメータ定義の定数を登録する。

	作成日 2017-05-17 taba
-----------------------------------------------------------------------------
=end

require("./Configure.rb");

class MyParamData
	def MyParamData.getParamData()
		rtc = Hash.new()

		myObjName = JobObjName::DIS_SEARCH_RESULT


# Jobのヘッダー情報
		wkAry = Hash.new()

		wkAry[Pconst::P_JOB_OBJ_HELP] = 'Remove duplicates from search results.'
		wkAry[Pconst::P_EXEC_CMD] = [
			ReqFileType::TYPE_FILTER_RESULT,
			{
				Pconst::JOB_CMD_DEFAULT => [
					"DistinctSearchResult/DistinctSearchResult.rb",
					Pconst::JOB_GR_DEFAULT
				]
			}
		]
		wkAry[Pconst::P_IN_FILE] = {
			ReqFileType::TYPE_FILTER_RESULT => [
				[
					ReqFileType::TYPE_FILTER_RESULT,
				],
				Pconst::CRT_IN_MULTI,
				"inFileCountCheckA",
			]
		};
		wkAry[Pconst::P_OUT_FILE] = {
			ReqFileType::TYPE_FILTER_RESULT => [
				ReqFileType::TYPE_FILTER_RESULT,
				nil,
				"%s.txt",
			]

		}

		rtc[Pconst::P_PARAM] = Hash.new()
		rtc[Pconst::P_PARAM][myObjName] = wkAry


# 起動時のパラメータの定義
		wkAry = nil
		wkAry = Array.new()

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_ITEM] = wkAry;


		wkAry.push([
			DisSRconst::DSR_IN_FILE_TYPE,
			'InFileType', '%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[DisSRconst::DSR_FILE_NORMAL,DisSRconst::DSR_FILE_NORMAL],
				[DisSRconst::DSR_FILE_DECOY,DisSRconst::DSR_FILE_DECOY],
			],
			{}
		])

		wkAry.push([
			DisSRconst::DSR_PSM_U_KEY,
			'PSM unique key', '%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[DisSRconst::DSR_U_KEY_MOD_DETAIL,DisSRconst::DSR_U_KEY_MOD_DETAIL],
				[DisSRconst::DSR_U_KEY_NO_MOD_DETAIL,DisSRconst::DSR_U_KEY_NO_MOD_DETAIL]
			],
			{}
		])

		wkAry.push([
			DisSRconst::DSR_MS2_PEAK_SELECT_BIN,
			'MS2PeakSelectBin', '%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[DisSRconst::DSR_MS2_M_BIN_MZ_Y,DisSRconst::DSR_MS2_M_BIN_MZ_Y],
				[DisSRconst::DSR_MS2_M_BIN_MZ_N,DisSRconst::DSR_MS2_M_BIN_MZ_N],
			],
			{
				Pconst::P_PARAM_DISABLE => [
					{
						DisSRconst::DSR_MS2_M_BIN_MZ_Y => false,
						DisSRconst::DSR_MS2_M_BIN_MZ_N => true,
					},
					[
						DisSRconst::DSR_MS2_BIN_MZ_RANGE
					],
				]
			}
		])

		wkAry.push([
			DisSRconst::DSR_MS2_BIN_MZ_RANGE,
			'M/Z bin range', '%s M/Z',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_PL_MZ_NUM,
			'Peak number of MS2 used for peptide assessment', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MAX_FLAG_CHG,
			'Max MS2 flagment charge', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

#		wkAry.push([
#			DisSRconst::DSR_MS2_PEAK_SELECT,
#			'MS2PeakSelect', '%s',
#			'',
#			Pconst::TYPE_SELECT,
#			Pconst::IN_CHK_REQUIRED,
#			[
#				[DisSRconst::DSR_MS2_MIN_INT,DisSRconst::DSR_MS2_MIN_INT],
#				[DisSRconst::DSR_MS2_DES_ORDER,DisSRconst::DSR_MS2_DES_ORDER],
#			],
#			{}
#		])

#		wkAry.push([
#			DisSRconst::DSR_MS2_MZ_CENTER,
#			'MS2 MZ Center', '%s',
#			'',
#			Pconst::TYPE_TEXT,
#			Pconst::IN_CHK_REQUIRED,
#			[],
#			{
#				Pconst::KEY_SIZE_VAL => 40
#			}
#		])

		wkAry.push([
			DisSRconst::DSR_MS2_TOL_L,
			'Pre MS2 tol. －', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MS2_TOL_R,
			'Pre MS2 tol. ＋', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MAIN_MS2_TOL_L,
			'Main MS2 tol. －', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MAIN_MS2_TOL_R,
			'Main MS2 tol. ＋', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MS2_TOLU,
			'MS2 tol(Unit)', '%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[DisSRconst::DSR_TOL_U_DA,DisSRconst::DSR_TOL_U_DA],
				[DisSRconst::DSR_TOL_U_PPM,DisSRconst::DSR_TOL_U_PPM]
			],
			{}
		])

		wkAry.push([
			DisSRconst::DSR_ION_KIND,
			'Ion type', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MIN_J_SCORE,
			'Min jPOST score', '%s',
			'',
			Pconst::TYPE_TEXT,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])

		wkAry.push([
			DisSRconst::DSR_MS2_PEAK_KEY,
			'MS2 key type', '%s',
			'',
			Pconst::TYPE_SELECT,
			Pconst::IN_CHK_REQUIRED,
			[
				[DisSRconst::DSR_MS2_KEY_TITLE,DisSRconst::DSR_MS2_KEY_TITLE],
				[DisSRconst::DSR_MS2_KEY_SCANNO,DisSRconst::DSR_MS2_KEY_SCANNO],
			],
			{}
		])

		wkAry.push([
			DisSRconst::DSR_UNI_SC_CONST,
			'UniScore const', '%s',
			'',
			Pconst::TYPE_HIDDEN,
			Pconst::IN_CHK_REQUIRED,
			[],
			{
				Pconst::KEY_SIZE_VAL => 40
			}
		])


# パラメータの横並びの定義
		wkAry = nil
		wkAry = Hash.new()

#		wkAry[DisSRconst::DSR_PL_MZ_NUM] = DisSRconst::DSR_MS2_PEAK_SELECT

		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_JOINT] = wkAry


# パラメータのランチャー情報
		wkAry = nil
		wkAry = Array.new()

		initPara = {
			DisSRconst::DSR_IN_FILE_TYPE => DisSRconst::DSR_FILE_NORMAL,
			DisSRconst::DSR_MS2_PEAK_SELECT_BIN => DisSRconst::DSR_MS2_M_BIN_MZ_Y,
			DisSRconst::DSR_MS2_BIN_MZ_RANGE => '100',
#			DisSRconst::DSR_MS2_BIN_MZ_RANGE => '50',
#			DisSRconst::DSR_MS2_PEAK_SELECT => DisSRconst::DSR_MS2_DES_ORDER,
#			DisSRconst::DSR_PL_MZ_NUM => '200',
#			DisSRconst::DSR_PL_MZ_NUM => '100',
#			DisSRconst::DSR_PL_MZ_NUM => '8',
			DisSRconst::DSR_PL_MZ_NUM => '12',
#			DisSRconst::DSR_PL_MZ_NUM => '4',
			DisSRconst::DSR_MAX_FLAG_CHG => '1',
#			DisSRconst::DSR_MS2_MZ_CENTER => '0',
			DisSRconst::DSR_MS2_TOL_L => '20',
			DisSRconst::DSR_MS2_TOL_R => '20',
#			DisSRconst::DSR_MAIN_MS2_TOL_L => '5',
#			DisSRconst::DSR_MAIN_MS2_TOL_R => '5',
#			DisSRconst::DSR_MAIN_MS2_TOL_L => '10',
#			DisSRconst::DSR_MAIN_MS2_TOL_R => '10',
			DisSRconst::DSR_MAIN_MS2_TOL_L => '20',
			DisSRconst::DSR_MAIN_MS2_TOL_R => '20',
			DisSRconst::DSR_MS2_TOLU => DisSRconst::DSR_TOL_U_PPM,
			DisSRconst::DSR_ION_KIND => 'b,y',
			DisSRconst::DSR_MIN_J_SCORE => '-100',
			DisSRconst::DSR_MS2_PEAK_KEY => DisSRconst::DSR_MS2_KEY_TITLE,
#			DisSRconst::DSR_MS2_PEAK_KEY => DisSRconst::DSR_MS2_KEY_SCANNO,
#			DisSRconst::DSR_PSM_U_KEY => DisSRconst::DSR_U_KEY_MOD_DETAIL,
			DisSRconst::DSR_PSM_U_KEY => DisSRconst::DSR_U_KEY_NO_MOD_DETAIL,
# bothMatchConst,singleMatchConst,bothUnMatchConst,tagHitConst,noTagHitConst
			DisSRconst::DSR_UNI_SC_CONST => '2,1,0,1,0',
		}

		initPara1 = initPara.clone()
		initPara1[DisSRconst::DSR_MS2_TOL_L] = '0.1'
		initPara1[DisSRconst::DSR_MS2_TOL_R] = '0.1'
		initPara1[DisSRconst::DSR_MAIN_MS2_TOL_L] = '0.1'
		initPara1[DisSRconst::DSR_MAIN_MS2_TOL_R] = '0.1'
		initPara1[DisSRconst::DSR_MS2_TOLU] = DisSRconst::DSR_TOL_U_DA

		initPara2 = initPara.clone()
		initPara2[DisSRconst::DSR_MS2_TOL_L] = '0.05'
		initPara2[DisSRconst::DSR_MS2_TOL_R] = '0.05'
		initPara2[DisSRconst::DSR_MAIN_MS2_TOL_L] = '0.05'
		initPara2[DisSRconst::DSR_MAIN_MS2_TOL_R] = '0.05'
		initPara2[DisSRconst::DSR_MS2_TOLU] = DisSRconst::DSR_TOL_U_DA

		initPara4 = initPara.clone()
		initPara4[DisSRconst::DSR_MS2_TOL_L] = '0.4'
		initPara4[DisSRconst::DSR_MS2_TOL_R] = '0.4'
		initPara4[DisSRconst::DSR_MAIN_MS2_TOL_L] = '0.4'
		initPara4[DisSRconst::DSR_MAIN_MS2_TOL_R] = '0.4'
		initPara4[DisSRconst::DSR_MS2_TOLU] = DisSRconst::DSR_TOL_U_DA

		initPara3 = initPara.clone()
		initPara3[DisSRconst::DSR_MS2_PEAK_SELECT_BIN] = DisSRconst::DSR_MS2_M_BIN_MZ_N
		initPara3[DisSRconst::DSR_PL_MZ_NUM] = '100'

		wkAry.push(['Default',initPara])
		wkAry.push(['Q-Exactive',initPara])
		wkAry.push(['LCQ,LTQ',initPara4])
		wkAry.push(['Orbi',initPara4])
		wkAry.push(['LTQ-FT',initPara4])
		wkAry.push(['TT5600',initPara1])
		wkAry.push(['TIMS',initPara2])
		wkAry.push(['NoBin100',initPara3])


		rtc[Pconst::P_PARAM][myObjName][Pconst::P_PARAM_LANCHER] = wkAry
		initPara = nil
		wkAry = nil

		return rtc;
	end
end
