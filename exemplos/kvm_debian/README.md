## Rodar uma VM com Terraform no KVM/Qemu

Copie a imagem gerada para o pool de armazenamento e lembre-se de fazer um refresh para que a imagem seja detectada. 
Se você usa o libvirt e virsh, pode rodar:

```
virsh pool-refresh default
```

A partir daí, a imagem já deve estar disponível no póol. Para subir a infra, rode os comandos:

```
terraform init
terraform plan -out plan
terraform apply plan
```
