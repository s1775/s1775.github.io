const proxyServer = 'HTTP proxy.example.org:3128; SOCKS5 proxy.example.org:1080; PROXY proxy.example.org:8080; DIRECT';
const dnsCache = {};

const localTldStorage = [
  '.home.arpa',
  '.internal',
];

const directTldStorage = [
  '.am',
  '.az',
  '.by',
  '.kg',
  '.kz',
  '.md',
  '.mn',
  '.ru',
  '.su',
  '.tatar',
  '.tj',
  '.tm',
  '.uz',
  '.xn--p1ai', // .рф
];

function fastResolve(host) {
  let ip = dnsResolve(host);
  if (dnsCache[host]) return dnsCache[host];
  if (ip) dnsCache[host] = ip;
  return ip;
}

function FindProxyForURL(url, host) {
  url = url.toLowerCase();
  host = host.toLowerCase();

  if (isPlainHostName(host)) return 'DIRECT';

  let ip = fastResolve(host);

  if (
    isInNet(ip, '127.0.0.0', '255.0.0.0') ||
    isInNet(ip, '10.0.0.0', '255.0.0.0') ||
    isInNet(ip, '172.16.0.0', '255.240.0.0') ||
    isInNet(ip, '192.168.0.0', '255.255.0.0')
  ) {
    return 'DIRECT';
  }

  if (localTldStorage.length !== 0) {
    for (let i = 0; i < localTldStorage.length; i++) {
      if (dnsDomainIs(host, localTldStorage[i])) return 'DIRECT';
    }
  }

  if (directTldStorage.length !== 0) {
    for (let i = 0; i < directTldStorage.length; i++) {
      if (dnsDomainIs(host, directTldStorage[i])) return 'DIRECT';
    }
  }

  return proxyServer;
}
