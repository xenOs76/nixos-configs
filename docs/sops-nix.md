# Sops-nix

## Create a key

Create an `age` key from an SSH one.
Only ed25519 keys are supported:

```shell
❯ nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i $HOME/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
❯ nix-shell -p ssh-to-age --run "sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key >> ~/.config/sops/age/keys.txt"
```

Extract the public key:

```
❯ nix-shell -p ssh-to-age --run "ssh-to-age -i $HOME/.ssh/id_ed25519.pub -o ~/.config/sops/age/xeno_at_zero-pub-key.txt"
```

## Test the key

```shell
❯ export SOPS_AGE_RECIPIENTS=$(cat ~/.config/sops/age/xeno_at_zero-pub-key.txt)

❯ cat test.yaml
secret: secret_value
nested:
  secret: |
    bla bla bla
    bla bla bla

❯ sops encrypt test.yaml > test.enc.yaml

❯ cat test.enc.yaml
secret: ENC[AES256_GCM,data:CO2JGBooT3vOKdAc,iv:yGfwI9Ye+c4PLGvyls79MTokZVubD1y0kCMJJlq/hOs=,tag:ZQmXglBH+2soqtu0ZvhpHQ==,type:str]
nested:
    secret: ENC[AES256_GCM,data:jtGA8YQr4epLq6ikB6uaFRBIzEK5wsLF,iv:WwrWX2ThpkPu9+dWlKNP+T8OPbWJnhGNFd+MOS3g+uk=,tag:kNaLoIOxYzceJeXnvgOvAQ==,type:str]
sops:
    kms: []
    gcp_kms: []
    azure_kv: []
    hc_vault: []
    age:
        - recipient: age1lsfvx7nwct987yezqud0tt9y05yhmcquckf0kalfqwrqfuygnvhsr09d5g
          enc: |
            -----BEGIN AGE ENCRYPTED FILE-----
            YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBZcnFyWHVEeG5qV1BlWVFK
            U3B5VGYxYW9ldW9ZM1lBcHhvb1doc2lBcUM0CjVWRHdhaERRY3o5Q3BSUm1EZm1n
            UjJRbFJpYmtBT3VHUFgrZ0FkcDFKZGMKLS0tIEJ6cWRrMzlDKzBoS1NTQjF2Z0cy
            ekdVeGQ0WHNjRUFDNXM0aW5JcFU2R1EK0ikpL7cnBe/kEmBqHWJao3nd+V3m3foi
            4aMJOasRhEYJZ9qRUtIne+9hJ5P9lPv2NJ6VFrt7U1mS7d+JK9U5Vg==
            -----END AGE ENCRYPTED FILE-----
    lastmodified: "2025-03-27T09:11:01Z"
    mac: ENC[AES256_GCM,data:Y2Z9zSh/f/a+TCPQtWVdaWQLGX+PbBhoDrYMlXVJy4glkIfzZHAveGrKpejBZ5wYS1PLJuxfs/nRxYgyZmK6+KZvnwTt3asAJhekEDrjw38m+fnxnpukFa8LaUWqCMs176v++QXEDeACTF5tfgIpqulhBzmCaiCiy0S1BcITmm0=,iv:a8Jzii57JizZGpQtz9wPRq3c4CI/o/qFq6WfWGMCysA=,tag:LC565HlUoUrwArE+v8bjHQ==,type:str]
    pgp: []
    unencrypted_suffix: _unencrypted
    version: 3.9.4

❯ sops decrypt test.enc.yaml
secret: secret_value
nested:
    secret: |
        bla bla bla
        bla bla bla
```


## Refs

* [Github - FiloSottile / age](https://github.com/FiloSottile/age)
* [SOPS: Simple And Flexible Tool For Managing Secrets](https://getsops.io/)
* [Github - getsops / sops](https://github.com/getsops/sops)
* [Github - Mic92 / ssh-to-age](https://github.com/Mic92/ssh-to-age)
* [Github - Mic92 / sops-nix](https://github.com/Mic92/sops-nix)
