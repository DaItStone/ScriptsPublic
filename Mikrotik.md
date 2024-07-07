# Phase 1: Define IPSec proposal

/ip ipsec proposal
add name=proposal1 auth-algorithms=sha256 enc-algorithms=aes-128-cbc lifetime=1h pfs-group=modp2048

# Explanation:
# Phase 1 (IKEv2 Proposal): This section defines the proposal used for IKE (Internet Key Exchange) Phase 1 negotiation.
# It specifies AES 128 encryption, SHA 256 hashing, DH Group 14 (modp2048) for Perfect Forward Secrecy (PFS), and other parameters.



# Phase 1: Define IPSec profile

/ip ipsec profile
add dh-group=modp2048 enc-algorithm=aes-128 lifetime=1h name=profile1 proposal=proposal1

# Explanation:
# Phase 1 (IPSec Profile): This section creates a profile that references the Phase 1 proposal (proposal1).
# It specifies AES 128 encryption, DH Group 14 (modp2048), and other parameters for IKEv2 Phase 1 negotiation.

# Configure IPSec peer

/ip ipsec peer
add address=<Barracuda_Public_IP> auth-method=pre-shared-key dh-group=modp2048 exchange-mode=ike2 generate-policy=port-strict passive=no secret=<pre-shared-key> proposal-check=obey local-address=<MikroTik_Local_IP> remote-address=<Barracuda_Public_IP>

# Explanation:
# IPSec Peer Configuration: This section configures the IPSec peer for establishing the VPN tunnel.
# It includes the Barracuda firewall's public IP address, pre-shared key authentication, DH Group 14 (modp2048), IKEv2 exchange mode,
# strict policy generation, and local/remote addresses for Phase 1 negotiation.

# Configure IPSec identity

/ip ipsec identity
add auth-method=secret generate-policy=port-strict peer=<Barracuda_Public_IP> policy-template-group=0 src-address=<MikroTik_Local_IP> src-port=500

# Explanation:
# IPSec Identity Configuration: This section specifies the local identity for IKEv2 negotiation.
# It uses pre-shared key authentication, enforces strict policy generation, specifies the Barracuda firewall's public IP address as the peer,
# and defines the local IP address and source port for Phase 1 negotiation.

# Phase 2: Define IPSec policy

/ip ipsec policy
add dst-address=<Barracuda_Local_Subnet> proposal=proposal1 sa-dst-address=<Barracuda_Public_IP> sa-src-address=<MikroTik_Local_IP> src-address=<MikroTik_Local_Subnet> tunnel=yes

# Explanation:
# Phase 2 (IPSec Policy): This section defines the IPSec policy for Phase 2 negotiation.
# It protects traffic between the specified subnets (MikroTik Local Subnet and Barracuda Local Subnet) using the Phase 1 proposal (proposal1).
# It specifies the destination and source addresses, as well as enables tunnel mode for IPSec encryption.

