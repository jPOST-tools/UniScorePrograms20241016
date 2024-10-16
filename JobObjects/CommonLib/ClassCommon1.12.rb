#
# Copyright (c) 2011 Eisai Co., Ltd. All rights reserved.
#

=begin
//------------------------------------------------------------------
	Module Pconst

	JobRequest-Rubyプログラムで使用する共通定数を登録する

	作成日2011-04-27 taba
//------------------------------------------------------------------
=end

module Pconst
# システムのConfFile
	P_JOBREQ_CONF_FILE = '../../../ConfFiles/JobRequestConf.json'

# ConfFileの項目へのアクセスキー
	P_RUBY_DIR = 'RubyDir'
	P_PHP_DIR = 'PHPdir'
	P_NODE_CTL_HOST = 'NodeControlHost'
	P_NODE_CTL_PROC_MON_PORT = 'NodeControlProcMonPort'
	P_NODE_CTL_CPU_ASS_PORT = 'NodeControlCpuAssPort'
	P_NODE_CTL_JOB_PROGRESS_PORT = 'NodeControlJobProgressPort'
	P_NODE_CTL_PROC_INFO_PORT = 'NodeControlProcInfoPort'

	P_USE_RS_RUBY = 'UseRSruby'
	P_NODE_RS_RUBY_DIR = 'NodeRSruby_RubyDir'
	P_NODE_RUBY_DIR = 'NodeRubyDir'
	P_NODE_PHP_DIR = 'NodePHPdir'

	P_NODE_CTL_NODES_CONFIG = 'NodesConfig'
	P_SSH_USER_NAME = 'SSH_userName'
	P_MASCOT_VER = 'MascotVersion'
	BACKUP_DISK_PATH = 'BackupDiskPath'

# 各JobObjにて定義が必要な項目
	P_PARAM = "Param"
	P_JOB_OBJ_HELP = "JobObjHelp"
	P_EXEC_CMD = "ExecCmd"
	P_PARAM_ITEM = "ParamItem"
	P_PARAM_JOINT = "ParamJoint"
	P_PARAM_DISABLE = "ParamDisable"
	P_PARAM_LANCHER = "ParamLancher"
	P_IN_FILE = "InFile"
	P_OUT_FILE = "OutFile"
	P_TEMP_FILE = "TempFile"
	P_STDOUT_FILE = "StdoutFile"
	P_SPLIT_FILE = "SplitFile"
	P_BEFORE_JOB_KEY = "BeforeJobKey"
	P_MANUAL_INPUT_FILE = "ManualInputFile"
	P_JOB_COUNT_OPTION = "JobCountOption"

# 分割するJobの動作の種類
	P_SPLIT_PARAM_SET_COUNT_EXEC = "SplitParamSetCountExec"

# Jobのテンプレートで定義が必要な項目
	P_EXEC_JOB = "ExecJob"
	P_JOB_CONT_EXEC = "JobContExec"
	P_JOB_FIX_NODE = "JobContFixNode"
	P_JOB_CONT_RETRY = "JobContRetry"

# ひとまとまりのJobが受けつける入力ファイル数
	CRT_IN_MULTI = "CrtInFileMulti"

# １つの実行単位のJobが出力するファイル数
	RESULT_SPLIT = "ResultSplit"

# Jobをどう動かすかの定義が必要な項目
	EXEC_ONLY_ONE = "ExecOnlyOne"
	EXEC_FILE_NUM = "ExecFileNum"
	EXEC_FILE_NUM_JOB_KYES = "ExecFileNumJobKeys"

# 各パラメータの想定するinput type
	TYPE_SELECT = "select"
	TYPE_TEXT = "text"
	TYPE_LIST = "list"
	TYPE_CHECKBOX = "checkbox"
	TYPE_HIDDEN = "hidden"
	TYPE_TREE = "tree"

# パラメータがtextの場合の入力エリアのsizeを取り出すキーワード
	KEY_SIZE_VAL = "RawSize"

# パラメータがselectの場合の表示エリアのsizeを取り出すキーワード
	KEY_SEL_SIZE_VAL = "SelSize"

# パラメータの入力チェックのパターンを示す定数
	IN_CHK_EMP_OK = "EmptyOk"
	IN_CHK_REQUIRED = "Required"

# Job起動時のコマンドを決めるときのデフォルト値のキーワード
	JOB_CMD_DEFAULT = "JobCmdDef"

# Jobグループの種類の定義
	JOB_GR_DEFAULT = "JobGrDefault"
	JOB_GR_OTHRE_PC = "JobGrOtherPC"
	JOB_GR_PILOT = "JobGrPilot"
	JOB_GR_MEMORY = "JobGrMemory"
	JOB_GR_MAXQ = "JobGrMaxq"
	JOB_GR_PHOSPEP = "JobGrPhospep"

# Jobを管理するフォルダー名
	JOB_TEMP_DIR = "../../../temp"


# Job要求ファイル、JobParam.php内のヘッダー情報へのキーワード
	P_JOB_HEADER = "JobHeader"
	P_JOB_COMMENT = "JobComment"
	P_JOB_STATUS_FILE = "JobStatusFile"
	P_JOB_EXEC_HOST = "JobExecHost"

# JobParam.phpをJsonに変換してくれるPHPプログラム
	P_JOB_PARAM_TO_JSON = '../../bin/JobParamToJson.php'
	P_JOB_PARAM_TO_JSON_R = '../../bin/JobObjParamDump.rb'

# 各オブジェクトで定義するファイル
	OBJ_VERSION_FILE = 'NowVersion.%s'
	OBJ_PARAM_FILE = 'GetParamData.%s'

# 複数ノードで実行時に必要な定数
	SSH_CMD_PATH = "ssh"
	SCP_CMD_PATH = "scp"
	JOB_NODE_EXEC_PATH = "JobRequest/JobObjects/bin/binExecDir"
	TYPE_TANDEM_RESULT = "TandemResult"
	JOB_RESULT_DIR = "../../../ResultFiles"

# 結果を格納するフォルダーの区切り文字
	RESULT_DIR_SEP = '^'

# サーチエンジンのタイプの識別文字
	S_ENG_MASCOT = 'Mascot'
	S_ENG_TANDEM = 'X!Tandem'
	S_ENG_MAX_QUANT = 'MaxQuant'
	S_ENG_COMET = 'Comet'
	S_ENG_PILOT = 'ProteinPilot'
	S_ENG_MSFRG = 'MSFragger'

# ピークリストのタイプの識別文字
	PL_AB_MSCON = 'mscon'
	PL_MAX_Q_PLIST = 'maxq'
	PL_MAX_Q_EXEC = 'maxqFin'
	PL_PILOT_PLIST = 'pilot'
	PL_PILOT_EXEC = 'pilotFin'
	PL_PROTEO_WIZD = 'wizd'
	PL_DISCOVERER = 'dsco'
	PL_MQ_WZD_MERGE = 'mqWzd'
end


=begin
//------------------------------------------------------------------
//	Class JobObjName
//
//	JobReqObjで必要なオブジェクトの名前を定義する。
//
//	作成日2010-10-26 taba
//------------------------------------------------------------------
=end

class JobObjName
# オブジェクト名の定義
				# 処理の種類.オブジェクト名

	XCALIBUR_PLIST		= "PeakList.XcaliburPlist"
	ANALIST_PLIST		= "PeakList.AnalystPlist"
	PROTEO_WIZ_PLIST	= "PeakList.ProteoWizardPlist"
	PROTEO_WIZ_PLIST_W	= "PeakList.ProteoWizardPlistW"
	PROTEO_WIZ_CID_HCD	= "PeakList.ProteoWizardCidHcd"
	MULTIPLE_PLIST_W	= "PeakList.MultiplePeakListW"
	MULTIPLE_PLIST		= "PeakList.MultiplePeakList"
	PRO_PILOT_PLIST		= "PeakList.ProteinPilotPlist"
	MAX_QUANT_PLIST		= "PeakList.MaxQuantPlist"
	MAX_QUANT_PLIST_W	= "PeakList.MaxQuantPlistW"
	MAX_QUANT_PL_CID_HCD	= "PeakList.MaxQuantPlistCidHcd"
	DISCOVERER_PLIST	= "PeakList.DiscovererPlist"
	DISCOVERER_PL_CID_HCD	= "PeakList.DiscovererPlistCidHcd"
	ML_PEAK_LIST_RAW	= "PeakList.ML_PeakListRaw"
	ML_PEAK_LIST_NPZ	= "PeakList.ML_PeakListNpz"
	ML_PEP_LIST_TO_NPZ	= "PeakList.ML_PepListToNpz"
	PEAKLIST_HIT_SUB	= "PeakList.PeakListHitSub"
	PEAKLIST_MERGE		= "PeakList.PeakListMerge"
	PEAKLIST_MERGE_P_MS2	= "PeakList.PeakListMergePreMS2"
	PEAKLIST_MERGE_P_MS2_CH	= "PeakList.PeakListMergePreMS2_CH"
	P_PARSE_PLIST		= "PeakList.pParsePlist"
	P_PARSE_PLIST_W		= "PeakList.pParsePlistW"
	DATA_ANA_PLIST		= "PeakList.DataAanaPlist"
	PEAKLIST_SPLIT		= "PeakList.PeakListSplit"
	UMPIRE_EXEC		= "PeakList.UmpireExec"

	TANDEM_EXEC		= "Psearch.TandemExec"
	MASCOT_EXEC		= "Psearch.MascotExec"
	PRO_PILOT_EXEC		= "Psearch.ProteinPilotExec"
	PRO_PILOT_EXEC_V5	= "Psearch.ProteinPilotExecV5"
	PRO_PILOT_FILTER	= "Psearch.ProteinPilotFilter"
	PRO_PILOT_FILTER_XML	= "Psearch.ProteinPilotFilterXml"
	MAX_QUANT_EXEC		= "Psearch.MaxQuantExec"
	MAX_QUANT_EXEC_W	= "Psearch.MaxQuantExecW"
	MAX_QUANT_EXEC_T	= "Psearch.MaxQuantExecT"
	MAX_QUANT_FILTER	= "Psearch.MaxQuantFilter"
	COMET_EXEC		= "Psearch.CometExec"
	COMET_FILTER		= "Psearch.CometFilter"
	MSFRAGGER_EXEC		= "Psearch.MSfraggerExec"
	MSFRAGGER_FILTER	= "Psearch.MSfraggerFilter"

	XCALIBUR_PEP_QUANT	= "Quant.XcaliburPepQuant"
	WIFF_PEP_QUANT		= "Quant.WiffPepQuant"
	ITRAQ_QUANT		= "Quant.ItraqQuant"
	ITRAQ_MS3_QUANT		= "Quant.ItraqMs3Quant"
	SKYLINE_QUANT		= "Quant.SkylineQuant"
	SKYLINE_FILTER		= "Quant.SkylineFilter"
	CALC_PEP_S_QVAL		= "Quant.CalcPepSeqQuantVal"
	IONQUANT_EXEC		= "Quant.IonQuantExec"

	INSERT_DUMMY_SEQ	= "Tool.InsertDummySeq"
	INSERT_DUMMY_SEQ_L	= "Tool.InsertDummySeqLerp"
	SEEDTOP_EXEC		= "Tool.SeedtopExec"
	STE_TO_PINFO		= "Tool.SeedtopExecToPinfo"
	DIS_SEARCH_RESULT	= "Tool.DistinctSearchResult"
	DIS_SEARCH_RESULT_SEQ	= "Tool.DistinctSearchResultSeq"
	PRECURSOR_PURIFY	= "Tool.PrecursorPurifyInfo"
	CALC_FDR		= "Tool.CalcFDR"
	CALC_PEP		= "Tool.CalcPEP"
	MERGE_JR_RESULT		= "Tool.MergeJobreqResult"
	ENZ_CHK_HIT_SEQ		= "Tool.EnzymeCheckHitSeq"
	JPOST_SCORE_V		= "Tool.JpostScoreView"
	JPOST_SCORE_T		= "Tool.JpostScoreTuning"
	RESULT_FILES_COPY	= "Tool.ResultFilesCopy"
	PHOSPEP_EXEC		= "Tool.PhospepExec"
	DEEP_RT_PLUS_EXEC	= "Tool.DeepRTplusExec"
#	PERCORATOR_EXEC		= "Tool.PercoratorExec"
	PERCORATOR_EXEC		= "Tool.PercolatorExec"
	JOBR_R_TO_MZ_TAB	= "Tool.JobReqResultToMZtab"
	JOBR_R_TO_PEP_XML	= "Tool.JobReqResultToPepXML"
	FAIMS_RAW_TO_MZXML	= "Tool.FaimsRawToMzxml"
	CHIM_SAME_P_CHK		= "Tool.ChimeraHitSamePeakCheck"


end


=begin
//------------------------------------------------------------------
//	Class ReqFileType
//
//	入力対象のファイルタイプを定義する。
//
//	作成日2010-10-26 taba
//------------------------------------------------------------------
=end

class ReqFileType
# 生データの種類
	TYPE_RAW_DATA = 'RawData'	# 全体の総称
	TYPE_LCQ = 'FileLCQ'		# 個別の種類
	TYPE_QSTAR = 'FileQSTAR'
	TYPE_TIMS = 'FileTIMS'
	TYPE_MZ_XML = 'FileMzXML'
	TYPE_MZ_ML = 'FileMzML'

					# 生データの拡張
	TYPE_QSTAR_SCAN = 'FileQSTARscan.RawExt'
	TYPE_QSTAR_WIFF2 = 'FileQSTARwiff2.RawExt';
	TYPE_TIMS_BIN = 'FileTIMSbin.RawExt'


# mgfだけとDataAnalysisPlistでanzlysis.tdfとanalysis.tdf_binとXXX.mgfの３つを
# 同時にアップロードするために、特別のRawExtの扱いとする。
	TYPE_TIMS_MGF = 'FileTIMSmgf.RawExt'


# ピークリストの種類
	TYPE_PEAK_LIST = 'PeakList'	# 全体の総称
	TYPE_PEAK_LIST_MASCOT = 'PeakList_Mascot'	# 個別の種類
	TYPE_PEAK_LIST_CID = 'PeakList_CID'	# 個別の種類
	TYPE_PEAK_LIST_HCD = 'PeakList_HCD'	# 個別の種類

# サーチエンジンの結果ファイルの種類
	TYPE_PPILOT_RESULT = 'ProPilotResult'
	TYPE_PPILOT_RESULT_XML = 'ProPilotResultXml'
	TYPE_PPILOT_RESULT_MZID = 'ProPilotResultMzid'
	TYPE_PPILOT_RESULT_TXT = 'ProPilotResultTxt'
	TYPE_PPILOT_RESULT_QUANT = 'ProPilotResultQuant'
	TYPE_MAX_Q_RESULT = 'MaxQuantResult'
	TYPE_MAX_Q_PARA = 'MaxQuantParaFile'
	TYPE_MAX_Q_PRO_GR = 'MaxQuantProteinGr'
	TYPE_MAX_Q_ALL_PEP = 'MaxQuantAllPeptides'
	TYPE_MAX_Q_EVD = 'MaxQuantEvidence'
	TYPE_MAX_Q_MD_SP_P = 'MaxQuantModSpPep'
	TYPE_MAX_Q_MSMS_S = 'MaxQuantMsmsScans'
	TYPE_MAX_Q_MS_S = 'MaxQuantMsScans'
	TYPE_MAX_Q_PEPT = 'MaxQuantPeptides'
	TYPE_MAX_Q_P_SITE = 'MaxQuantPhosSite'
	TYPE_COMET_RESULT = 'CometResult'

# CSVファイルの種類
	TYPE_TEXT_CSV = 'Text_CSV'		# 全体の総称
	TYPE_FILTER_RESULT = 'FilterResult'	# 個別の種類
	TYPE_FILTER_RESULT_DECOY = 'FilterResultDecoy'
	TYPE_FILTER_RESULT_CID = 'FilterResultCID'
	TYPE_FILTER_RESULT_CID_DECOY = 'FilterResultCIDdecoy'
	TYPE_M_FLT_Q_THERMO = 'MascotFilterQuantThermo'
	TYPE_A_FLT_Q_ITRAQ = 'AllFilterQuantItraq'
	TYPE_PPILOT_R_PRO_SUMMARY = 'ProPilotResult_ProteinSummary'
	TYPE_JSCORE_TUN_RESULT = 'JpostScoreTuningResult'
	TYPE_PEAK_CLUSTER = 'PeakCluster'	# DIA-UmpireExecで使用

# ProteinPilotのパラメータファイルの定義
	TYPE_PP_PARAM	= 'PP_Param'

	# jsonのHashへのキー
	KEY_SAMPLE_TYPE = 'UI_SAMPLE_TYPE'
	KEY_CYS_ALKYLATION = 'UI_CYS_ALKYLATION'
	KEY_DIGESTION = 'UI_DIGESTION'
	KEY_SPECIAL_FACTOR = 'UI_SPECIAL_FACTOR'
	KEY_INSTRUMENT = 'UI_INSTRUMENT'
	KEY_SEARCH_EFFORT = 'UI_SEARCH_EFFORT'
	KEY_ID_FOCUS = 'UI_ID_FOCUS'
	KEY_QUANT_TYPE = 'UI_QUANT_TYPE'
	KEY_MIN_UNUSED_PROTSCORE = 'UI_MIN_UNUSED_PROTSCORE'
	KEY_MSTOLERANCE = 'MSTOLERANCE'
	KEY_MSTOLERANCE_U = 'MSTOLERANCE_U'
	KEY_MSMSTOLERANCE = 'MSMSTOLERANCE'
	KEY_MSMSTOLERANCE_U = 'MSMSTOLERANCE_U'
	KEY_FASTA = 'FASTA'
	KEY_PARAGON_VERSION = 'PARAGON_VERSION'

# Skylineの特殊ファイルの定義
	TYPE_SKYLINE_XML = 'SkylineXML'
	TYPE_SKYLINE_SKYD = 'SkylineSkyd'
	TYPE_SKYLINE_BLIB = 'SkylineBlib'

# Jsonファイルの種類
	TYPE_TEXT_JSON = 'Text_JSON'		# 全体の総称
	TYPE_SEEDTOP_RESULT = 'SeedtopResult'	# 個別の種類

# CsvTitleに付加情報を追加するときのセパレータ
	CSV_TITLE_SEP = ':' 

# TandemFilterで必要なタイトル
	CSV_RAW_DATA_FILE = 'RawdataFile'
	CSV_PEAK_LIST_FILE = 'PeakListFile'
	CSV_PEPT_EXPT = 'PeptExpt'
	CSV_CALC_MZ = 'CalcMz'
	CSV_CALC_MASS = 'CalcMass'
	CSV_CHARGE = 'Charge'
	CSV_BEFORE_SEQ = 'FwdSeq'
	CSV_SEQ = 'Seq'
	CSV_BEHIND_SEQ = 'BwdSeq'
	CSV_MOD = 'Mod'
	CSV_MOD_DETAIL = 'ModDetail'
	CSV_RET_TIME = 'RetTime'
	CSV_PEAK_COMMENT = 'Title'
	CSV_PRECURSOR_INT = 'PrecursorIntensity'
	CSV_DB_NAME = 'DBname'

# CSVファイルのタイトル文字の定義
	CSV_NO = 'no'

# XcaliburPepQuantで必要なタイトル
	CSV_PEP_RATIO = 'Ratio'
	CSV_PEP_RATIO_SD = 'LH_RatioSD'
	CSV_PEP_INT = 'PepIntensity'
	CSV_PEP_AREA = 'PepArea'
	CSV_PEP_TARGET_MZ = 'PepTargetMz'
	CSV_PEP_RT_START = 'PepRtimeStart'
	CSV_PEP_RT_PEAK = 'PepRtimePeak'
	CSV_PEP_RT_END = 'PepRtimeEnd'
	CSV_PEP_SMOOTH_COUNT = 'PepSmoothCount'
	CSV_PEP_PEAK_COUNT = 'PepPeakCount'
	CSV_PEP_TIC_RT = 'PepTicRtime'
	CSV_PEP_TIC_INT = 'PepTicInt'
	CSV_PEP_TIC_INT_RAW = 'PepTicIntRaw'
	CSV_PEP_HALF_WIDTH = 'PepHalfWidth'
	CSV_PEP_PRE_INFO_MZ = 'PepPreInfoMz'
	CSV_PEP_PRE_INFO_INT = 'PepPreInfoInt'
	CSV_PEP_SYMMETRY_FACT = 'PepSymmetryFacter'

# SkylineQuantで必要なタイトル
	CSV_ISOTOPE_DOTP = 'IsotopeDotp'

# InsertDummySeqで必要なタイトル
	CSV_DUMMY_SEQ = 'DummySeq'
	CSV_MULTI_RTIME_GROUP = 'MultiRtimeGroup'
	CSV_IDENT_FILE_NM = 'IdentFileName'

# Itraq定量で必要なタイトル
	CSV_QUANT_ITRAQ = 'iTRAQ:%s'
	CSV_QUANT_ITRAQ_MS3 = 'QuantMs3scanNo'

# SeedtopExecToPinfoで必要なタイトル
	CSV_DB_KEY_NAME = 'AccNum'
	CSV_PROT_NAME = 'ProtDescription'
#	CSV_MAIN_DB_KEY_NUM = 'MainProteinIDNum'
#	CSV_MAIN_DB_KEY_IDS = 'MainProteinIDs'
	CSV_DB_KEY_ID_NUM = 'ProteinIDNum'
	CSV_DB_KEY_IDS = 'ProteinIDs'
	CSV_PROT_NAMES = 'ProteinNames'
	CSV_GENE_NAMES = 'GeneNames'
	CSV_UNIPROT_IDS = 'UniprotIDs'
	CSV_PEP_SEQS = 'PeptideSeqs'
	CSV_SEQ_COVERAGE = 'SeqCoverage[%}'
	CSV_SEQ_LENGTH = 'SeqLength'
	CSV_HIT_PEP_NUM = 'PeptidesNum'
	CSV_UNQ_PEP_NUM = 'UniquePeptidesNum'
	CSV_HIT_PEP_NUM_FILE = 'PeptidesNum:'
	CSV_UNQ_PEP_NUM_FILE = 'UniquePeptidesNum:'

# UnimodToCsvで必要なタイトル
	CSV_UNI_MOD_R_ID = "RecordID"
	CSV_UNI_MOD_TITLE = "ModTitle"
	CSV_UNI_POSTTION = "Position"
	CSV_UNI_SITE = "Site"
	CSV_UNI_CLASSIFICATION = "Classification"
	CSV_UNI_COMPOSITION = "Composition"
	CSV_UNI_MONO_MASS = "MonoMass"
	CSV_UNI_AVGE_MASS = "AvgeMass"
	CSV_UNI_N_LOSS_MONO_MASS = "NeutralLossMonoMass"
	CSV_UNI_N_LOSS_AVGE_MASS = "NeutralLossAvgeMass"
	CSV_UNI_N_LOSS_COMPOSITION = "NeutralLossComposition"
	CSV_UNI_MASCOT_MOD = "MascotMod"

# ProteinPilotFilterで必要なタイトル
	CSV_OBS_MASS = 'ObsMass'
	CSV_OBS_MZ = 'ObsMz'
	CSV_DELTA_MASS = 'DeltaMass'
	CSV_PROT_MASS = 'ProtMass'
	CSV_PROT_SCORE = 'ProtScore'
	CSV_PROT_EXPT = 'ProtExpt'
	CSV_PRPT_COUNT = 'PeptCnt'
	CSV_PEPT_SCORE = 'PeptScore'
	CSV_DELTA_SCORE = 'DeltaScore'
	CSV_MISS_CLVG = 'MissClvg'
	CSV_SEARCH_ENGINE = 'Engine'
	CSV_PEPT_HOMO = 'PeptHomo'
	CSV_PEPT_ID = 'PeptID'
	CSV_PEPT_BOLD = 'PeptBold'
	CSV_PEPT_RED = 'PeptRed'
	CSV_PEPT_CHECK = 'PeptCheck'
	CSV_PEPT_PARENT = 'PeptsParet'
	CSV_RESULT_URL = 'ResultURL'
	CSV_PROT_URL = 'ProtURL'
	CSV_PEPTS_URL = 'PeptsURL'
	CSV_PEPTS_URL_LORIKEET = 'PeptsURL_lorikeet'
	CSV_3D_PEAK_VIEW = '3D_PeakView'
	CSV_UNIPROT_URL = 'UniprotURL'
	CSV_IDENTITY = 'Identity'
	CSV_GENE_SYMBOL = 'GeneSymbol'
	CSV_GENE_DESC = 'GeneDescription'
	CSV_TYPE_OF_GENE = 'TypeOfGene'
	CSV_MAP_LOCATION = 'MapLocation'
	CSV_PROTEIN_SEQ = 'ProteinSeq'
	CSV_MULTI_HIT_NUM = 'MultiHitNum'
	CSV_ONE_OVER_K0 = '1/K0'

# DistinctSearchResultで必要なタイトル
	CSV_SCAN_NO = 'ScanNo'
	CSV_PL_HIT_COUNT = 'PeakListHitCount'
	CSV_ENG_HIT_COUNT = 'EngHitCount'
	CSV_PL_ENG_HIT_SCORE = 'PL_EngHitScore'
	CSV_JPOST_SCORE = 'jPostScore'
	CSV_M_FLAG_DETAIL = 'MatchFragDetail'
	CSV_M_IMMO_DETAIL = 'MatchImmoniumDetail'
	CSV_M_FLAG_COUNT = 'MatchFragCount'
	CSV_UM_FLAG_COUNT = 'UnMatchFragCount'
	CSV_HIT_PART_SEQ = 'HitPartSeq'
	CSV_M_FLAG_INT_P = 'MatchFragInt%'
	CSV_M_FLAG_INT_SUM = 'MatchFragIntSum'
	CSV_MS2_TOL_DIFF_MZ = 'Ms2TolDiffMz'
	CSV_MS2_P_INFO = 'Ms2PeakInfo'
=begin
	CSV_HIT_ION_SUM = 'HitIonCountSum'
	CSV_HIT_ION_J_SUM = 'HitIonJointSum'
	CSV_NO_HIT_ION_SUM = 'NoHitIonCountSum'
	CSV_NO_HIT_ION_J_SUM = 'NoHitIonJointSum'
=end
	CSV_B_HIT_ION_SUM = 'BothHitIonSum'
	CSV_S_HIT_ION_SUM = 'SingleHitIonSum'
	CSV_B_NO_HIT_ION_SUM = 'BothNoHitIonSum'
	CSV_HIT_TAG_LEN_JOINT = 'HitTagLenJoint'
	CSV_NO_HIT_TAG_LEN_JOINT = 'NoHitTagLenJoint'
	CSV_MAX_TAG_LEN = 'MaxtagLen'
	CSV_TAG_LEN_TITLE = ':TagLen:'

	CSV_HIT_AMINO_PT = 'HitAminoPt'

	CSV_SCORE_MASCOT = 'Mascot-IonScore'
	CSV_SCORE_TANDEM = 'Tandem-Hyperscore'
	CSV_SCORE_MAXQUANT = 'MaxQuant-Score'
	CSV_SCORE_COMET = 'Comet-Xcorr'
	CSV_SCORE_COMET_SP = 'Comet-Spscore'
	CSV_SCORE_PILOT = 'ProteinPilot-Score'
	CSV_SCORE_MSFRG = 'MSFragger-Hyperscore'

	CSV_FLAG_THO_SER = 'FragThoreticalSeries'
	CSV_FLAG_MATCH_INFO = 'FragMatchingInfo'

# DistinctSearchResultSeqで必要なタイトル
	CSV_SAME_S_SCAN_NO = 'SameSeqScanNo'
	CSV_SAME_S_CHARGE = 'SameSeqCharge'
	CSV_SAME_S_RTIME = 'SameSeqRtime'
	CSV_SAME_S_JSCORE = 'SameSeqjPOSTscore'
	CSV_SAME_S_OBS_M = 'SameSeqObsMass'
	CSV_SAME_S_PL_ENG_SCORE = 'SameSeq_PL_EngHitScore'
	CSV_SAME_S_RAW_F = 'SameSeqRawFile'
	CSV_SAME_P_CONFM_S = 'SameSeq_Phospho_ConfimedSite'
	CSV_SAME_P_AMBI_S = 'SameSeq_Phospho_AmbiguousSite'
	CSV_HIT_PMS_COUNT = 'HitPsmCount'
	CSV_SAME_S_Q_COM = 'SameSeq_'
#	CSV_P_PSM_COUNT = 'Phospho_PsmCount'
#	CSV_O_PSM_COUNT = 'Other_PsmCount'

# CalcFDRで必要なタイトル
	CSV_PEP_FDR = 'PepFDR'

# PhospepExecで必要なタイトル
	CSV_MAN_CONFM = 'manual confirmation'
	CSV_CONFM_SITE = 'confimed site'
	CSV_AMBI_SITE = 'ambiguous site'
	CSV_P_CONFM_SITE = 'Phospho_ConfimedSite'
	CSV_P_AMBI_SITE = 'Phospho_AmbiguousSite'

# MaxQuantFilterで必要なタイトル
	CSV_MAXQ_PEP_INT = 'MaxqPepIntensity'

# CalcPEPで必要なタイトル
	CSV_PEP_PEP = 'PepPEP'
	CSV_NORMAL_HIT_NUM = 'NormalHitCount'
	CSV_DECOY_HIT_NUM = 'DecoyHitCount'

# DeepRTplusで必要なタイトル
	CSV_L_RET_TIME = 'CalcRetTime'

# PercoratorExecで必要なタイトル
	CSV_ION_HIT_SUM  = 'IonHitSum'
	CSV_TAG_HIT_SUM = 'TagHitSum'
	CSV_TAG_NO_HIT_SUM = 'TagNoHitSum'
	CSV_SEQ_LEN = 'SeqLen'
	CSV_IQR_F_DEL_M_DA = 'IQRfragDeltaMass_Da'
	CSV_IQR_F_DEL_M_PPM = 'IQRfragDeltaMass_ppm'
	CSV_MF_DEL_M_DA = 'MeanFragDeltaMass_Da'
	CSV_MF_DEL_M_PPM = 'MeanFragDeltaMass_ppm'
	CSV_MAF_DEL_M_DA = 'MeanAbsFragDeltaMass_Da'
	CSV_MAF_DEL_M_PPM = 'MeanAbsFragDeltaMass_ppm'
	CSV_PCO_SVM_SCORE = 'Percorator_svmScore'
	CSV_PCO_Q_VAL = 'Percorator_qValue'
	CSV_PCO_PEP_VAL = 'Percorator_pepVal'

# IonQuantExecで必要なタイトル
	CSV_AX_FR_ID = 'apex_frame_ID'
	CSV_R_MASS_DEV = 'relative_mass_deviation'
	CSV_AX_RTIME = 'apex_retention_time'
	CSV_RTIME_ST = 'retention_time_begin'
	CSV_RTIME_EN = 'retention_time_end'
	CSV_AX_ION_MOB = 'apex_ion_mobility'
	CSV_ION_MOB_ST = 'ion_mobility_begin'
	CSV_ION_MOB_EN = 'ion_mobility_end'
#	CSV_INTENSITY = 'intensity'
	CSV_INT_ISO_N = 'intensity%d'
	CSV_PPM_ISO_N = 'ppm%d'

# ChimeraHitSamePeakCheckで必要なタイトル
	CSV_DUP_F_O_CHIME = 'DupFragWithOtherChimeras%'

end

=begin
//------------------------------------------------------------------
	Module PepHitConst

	PepHitViewで使用する定数を定義する。

	作成日2016-01-06 taba
//------------------------------------------------------------------
=end

module PepHitConst
# Get変数へのアクセスキー
	GET_FILE = 'file'
	GET_LINE_NO = 'lineNo'
	GET_MASS_ERROR = 'massErr'
	GET_MASS_ERROR_UNIT = 'massErrU'
	GET_MS2_NUM = 'ms2Num'
	GET_MS2_BIN_RANGE = 'ms2binRange'
	GET_PRE_ERROR = 'preErr'
	GET_PRE_ERROR_UNIT = 'preErrU'
	GET_CANCEL_FRAG_NO = 'calcelFragNo'
	GET_IS_MS2_KEY_SCAN = 'isMs2KeyScan'
	GET_MS2_MZ_CENTER = 'ms2mzCenter'

	PEP_HIT_VIEW = 'ProteoAnalysis/PepHitView.php'
	PEP_HIT_VIEW_RB = 'ProteoAnalysis/PepHitView.rb'
	MS_PEAK_VIEW = 'MsPeakView/MsPeakView.php?inRawFile=%s&smoothLevel=5&smoothCount=1&hitMZ=%.4f&mzRange=0.02&hitRtime=%f&charge=%d&title='
end
