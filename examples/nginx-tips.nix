{}:

[
    {
        ifValues = ["services.nginx.virtualHosts.*.enableACME"];
        thenValue = "services.nginx.virtualHosts.*.forceSSL";
        weight = 30;
    }
]