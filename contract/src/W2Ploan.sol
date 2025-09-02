// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract W2Ploan{
     // --- 状態変数 ---

    // Lenderごとの預金額を管理
    // mapping(Lenderのアドレス => 預金額)
    mapping(address => uint256) public lenderDeposits;

    // プールされている資金の合計額
    uint256 public totalPooledEther;

    // ローン情報を管理するための構造体
    struct Loan {
        address borrower;      // 借り手のアドレス
        uint256 amount;          // 借入額
        uint256 interestRate;    // 金利 (例: 5%なら5)
        uint256 repaymentDeadline; // 返済期限 (Unixタイムスタンプ)
        bool isRepaid;         // 返済済みか
        bool isDefaulted;      // デフォルト状態か
    }

    // ローンIDを管理するためのカウンター
    uint256 private nextLoanId;

    // ローンIDからローン情報を取得
    // mapping(ローンID => Loan情報)
    mapping(uint256 => Loan) public loans;

    // --- 機能 ---
    event Deposited(address indexed from, uint256 amount);

    function deposit()public payable{
        require(msg.value > 0, "Deposit amount must be greater than zero");
        emit Deposited(msg.sender, msg.value);
    }

    function  withdraw(uint256 _amount) public {
        require(_amount > 0, "Withdraw amount must be greater than zero");
        require(lenderDeposits[msg.sender] >= _amount, "Insufficient balance to withdraw");
        lenderDeposits[msg.sender] -= _amount;
        totalPooledEther -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function borrow(uint256 _amount, address payable _to) public payable {
        // ここに貸借ロジック

        require(_amount > 0, "Borrow amount must be greater than zero");
        require(_to != address(0), "Invalid recipient address");
        require(totalPooledEther >= _amount, "Insufficient pooled funds");
        Loan memory newLoan = Loan({
            borrower: msg.sender,
            amount: _amount,
            interestRate: 5, // 例として5%の金利
            repaymentDeadline: block.timestamp + 30 days, // 30日後を返済期限に設定
            isRepaid: false,
            isDefaulted: false
        });
        loans[nextLoanId] = newLoan;
        nextLoanId++;
        totalPooledEther -= _amount;
        _to.transfer(_amount);
    }

    function repay(uint256 _loanId) public payable {
        require(_loanId < nextLoanId, "Invalid loan ID");
        Loan storage loan = loans[_loanId];
        require(!loan.isRepaid, "Loan already repaid");
        require(!loan.isDefaulted, "Loan is in default");
        require(msg.value >= loan.amount + (loan.amount * loan.interestRate / 100), "Insufficient repayment amount");
        loan.isRepaid = true;
        totalPooledEther += msg.value;   
    }
}