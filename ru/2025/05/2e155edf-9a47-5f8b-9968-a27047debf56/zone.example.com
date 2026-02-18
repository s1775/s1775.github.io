$TTL 24h
$ORIGIN example.com.
; SOA
@                   IN  SOA     ns1.example.com. postmaster.example.com. (
                                2025031500  ; Serial
                                10m         ; Refresh
                                1h          ; Retry
                                1w          ; Expire
                                6m )        ; Negative Cache TTL
; NS
@                   IN  NS      ns1.example.com.
@                   IN  NS      ns2.example.com.
ns1                 IN  A       192.168.1.2
ns2                 IN  A       192.168.1.3
; MAIN
@                   IN  A       192.168.1.5
www                 IN  CNAME   @
; MAIL
@                   IN  MX  10  mail.example.com.
mail                IN  A       192.168.1.6
; TXT
@                   IN  TXT     "v=spf1 a mx ~all"
_dmarc              IN  TXT     "v=DMARC1; p=none; rua=mailto:postmaster@example.com; ruf=mailto:postmaster@example.com; adkim=r; aspf=r"
dkim._domainkey     IN  TXT     "v=DKIM1; p=TOKEN"
