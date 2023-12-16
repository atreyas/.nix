{ impermanence, ... }: 
 
{
  environment.persistence."/persist" = {
    #hideMounts = true;
    directories = [
      "/etc/hashed-passwords"
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nix/id_rsa"
    ];
  };  
}
