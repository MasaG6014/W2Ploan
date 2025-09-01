# WP2loan
## 仕様
**zkなし版の仕様**
### エンティティ
- Issuer 
- Borrower
	- Ethereumアドレスによって指定される
- Lender
	- Ethereumアドレスによって指定される
- Credit Report
	- 自身の信用情報に関する情報。信用スコアの算出に利用することができる
### 流れ
1. SetUp
	1. Lenderが貸与する金額と貸与の基準をスマートコントラクトに与える
	2. Issuerが、Borrowerの信用情報を収集し、Borrowerに対してCredit Reportを発行する
	3. BorrowerがCredit ReportからCredit Scoreを算出する
2. Borrow(On chain)
	1. Borrowerがスマートコントラクトに、自身のスコアと貸与金額の送金先アドレスを入力する
	2. スマートコントラクトが、Borrowerのスコアと貸与基準から、貸与の可否を判断する
	3. スマートコントラクトが、貸与可能と判断すれば、Borrowerの送金先アドレスに指定された金額を送金する
3. Repay
	1. Borrowerが返済期限までに利子こみの返済金額をスマートコントラクトに送金する
	2. 返済期限までにBorrowerが返済した場合、返済実績が（where）に記録される
	3. 返済期限までにBorrowerが返済しなかった場合、default履歴が（where）に記録される