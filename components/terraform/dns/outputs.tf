output "domain_name" {
  value       = module.dns.domain_name
  description = "The domain name, which consists of the resource subdomain, subnet's DNS label, the VCN's DNS label, and the oraclevcn.com domain"
}
