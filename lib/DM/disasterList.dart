class Disasterlist {
  final String BBS_NO;
  final String BBS_ORDR;
  final String CONT;
  final String FRST_REGIST_DT;
  final String IDX_NO;
  final String LAST_MODF_DT;
  final String QRY_CNT;
  final String RNUM;
  final String SJ;
  final String USR_EXPSR_AT;

  Disasterlist({
    required this.BBS_NO,
    required this.BBS_ORDR,
    required this.CONT,
    required this.FRST_REGIST_DT,
    required this.IDX_NO,
    required this.LAST_MODF_DT,
    required this.QRY_CNT,
    required this.RNUM,
    required this.SJ,
    required this.USR_EXPSR_AT
  });

  factory Disasterlist.fromJson(Map<String, dynamic> json) {
    return Disasterlist(
      BBS_NO: json['BBS_NO'] as String,
      BBS_ORDR: json['BBS_ORDR'] as String,
      CONT: json['CONT'] as String,
      FRST_REGIST_DT: json['FRST_REGIST_DT'] as String,
      IDX_NO: json['IDX_NO'] as String,
      LAST_MODF_DT: json['LAST_MODF_DT'] as String,
      QRY_CNT: json['QRY_CNT'] as String,
      RNUM: json['RNUM'] as String,
      SJ: json['SJ'] as String,
      USR_EXPSR_AT: json['USR_EXPSR_AT'] as String,
    );
  }
}