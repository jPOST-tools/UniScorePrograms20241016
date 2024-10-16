# encoding: utf-8
#
# Copyright (c) 2017 Department of Molecular and Cellular Bioanalysis,
# Graduate School of Pharmaceutical Sciences,
# Kyoto University. All rights reserved.
#

=begin
-----------------------------------------------------------------------------
	DisSRconst

	DistinctSearchResultで使用する定数を管理。

	作成日 2017-05-11 taba
-----------------------------------------------------------------------------
=end

module DisSRconst
# パラメータへのアクセスキー

	DSR_FILE_NORMAL = 'Normal'
	DSR_FILE_DECOY = 'Decoy'

	DSR_MS2_M_BIN_MZ_Y = 'yes'
	DSR_MS2_M_BIN_MZ_N = 'no'

#	DSR_MS2_MIN_INT = 'MinInt'
#	DSR_MS2_DES_ORDER = 'DecDrder'

	DSR_TOL_U_PPM = 'ppm'
	DSR_TOL_U_DA = 'Da'
	DSR_TOL_U_DA_FULL = 'Daltons'

	DSR_MS2_KEY_SCANNO = 'Key_ScanNo'
	DSR_MS2_KEY_TITLE = 'Key_Title'

	DSR_U_KEY_MOD_DETAIL = 'ScanNo+Seq+Chg+ModDetail'
	DSR_U_KEY_NO_MOD_DETAIL = 'ScanNo+Seq+Chg'

	DSR_IN_FILE_TYPE = 'DistinctSearchResult.InFileType'
	DSR_MS2_PEAK_SELECT_BIN = 'DistinctSearchResult.MS2PeakSelectBin'
	DSR_MS2_BIN_MZ_RANGE = 'DistinctSearchResult.BinRange'
#	DSR_MS2_PEAK_SELECT = 'DistinctSearchResult.MS2PeakSelect'
	DSR_PL_MZ_NUM = 'DistinctSearchResult.PlistMzNum'
#	DSR_MS2_MZ_CENTER = 'DistinctSearchResult.Ms2MZcenter'
	DSR_MS2_TOL_L = 'DistinctSearchResult.Ms2TolL'
	DSR_MS2_TOL_R = 'DistinctSearchResult.Ms2TolR'
	DSR_MAIN_MS2_TOL_L = 'DistinctSearchResult.MainMs2TolL'
	DSR_MAIN_MS2_TOL_R = 'DistinctSearchResult.MainMs2TolR'
	DSR_MS2_TOLU = 'DistinctSearchResult.Ms2TolU'
	DSR_ION_KIND = 'DistinctSearchResult.IonKind'
	DSR_MIN_J_SCORE = 'DistinctSearchResult.Min_jPOSTScore'
	DSR_MS2_PEAK_KEY = 'DistinctSearchResult.MS2peakKey'
	DSR_PSM_U_KEY = 'DistinctSearchResult.PSM_UniqueKey'
	DSR_MAX_FLAG_CHG = 'DistinctSearchResult.MaxFlagCharge'
	DSR_UNI_SC_CONST = 'DistinctSearchResult.UniScoreConst'


end

