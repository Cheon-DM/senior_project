class GuideSQL {
  final int index1;
  final int index2;
  final int index3;
  final String txt;

  GuideSQL(
  {
    required this.index1,
    required this.index2,
    required this.index3,
    required this.txt
  }
      );

  Map<int, Object?> toMap() {
    return <int, Object?>{
      1 : index1,
      2: index2,
      3 : index3,
      4 : txt,
    };
  }

}
