{}:

[
    {
        ifValues = ["accounts.email.accounts.*.gpg.encryptByDefault" "programs.gpg.enable"];
        thenValue = "accounts.email.accounts.*.gpg.signByDefault";
        weight = 10;
    }
]