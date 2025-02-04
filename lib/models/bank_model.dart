import 'package:letsmerge/widgets/c_tag.dart';

class BankInfo {
  final String name;
  final TagColor color;

  BankInfo({required this.name, required this.color});
}

final List<BankInfo> bankList = [
  BankInfo(name: '신한은행', color: TagColor.blue),
  BankInfo(name: '국민은행', color: TagColor.yellow),
  BankInfo(name: '우리은행', color: TagColor.cyan),
  BankInfo(name: '농협은행', color: TagColor.green),
  BankInfo(name: '카카오뱅크', color: TagColor.yellow),
  BankInfo(name: '토스뱅크', color: TagColor.blue),
  BankInfo(name: 'IBK기업은행', color: TagColor.blue),
  BankInfo(name: '하나은행', color: TagColor.teal),
  BankInfo(name: '새마을금고', color: TagColor.cyan),

];