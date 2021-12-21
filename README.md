# Packer Cloud Images

![GitHub](https://img.shields.io/github/license/lucaslehnen/packer-cloud-image)
![Packer](https://img.shields.io/badge/Packer-1.7.8-blue)
[![wakatime](https://wakatime.com/badge/github/lucaslehnen/packer-cloud-image.svg)](https://wakatime.com/badge/github/lucaslehnen/packer-cloud-image)


Este template Packer constrói imagens de diistribuições GNU/Linux, configurando o cloud-init, a fim de permitir a inicialização adequada nos provedores de cloud e virtualização. O objetivo é prover uma alternativa às imagens de cloud oficiais.

Use para fins de estudo apenas.
Este repositório nasceu a partir do projeto do laboratório pessoal (https://github.com/lucaslehnen/homelab).

Provedores atualmente suportados:

- KVM/Qemu

Distribuições atualmente suportadas:

- Debian 11

# Como utilizar

## Configuração das variáveis

Todas as variáveis estão descritas no arquivo `variables.pkr.hcl`. Para definir seus valores, um dos meios é criando um arquivo com `.auto.pkrvars.hcl` para que seja carregado automaticamente ou informar o mesmo com `-var-file="variables.pkrvars.hcl"`. 

As variáveis em si podem ser definidas neste formato:
``` 
cpus = 4
disk_size = 20000
memory = 4096
``` 

Veja a documentação do Packer para mais detalhes. 

## Com KVM/QEmu

### Pré-requisitos

Atualmente o plugin do Packer para o KVM/Qemu não permite conectar remotamente para o build. Já há uma [issue](https://github.com/hashicorp/packer-plugin-qemu/issues/10) lançada para tal, mas no momento de construção deste repositório, a mesma ainda estava aberta. 

O Packer e o Qemu deverão estar instalados na mesma máquina que irá executar os comandos de build.

As versões testadas foram:

 - Packer: 1.7.8
 - Qemu: 5.2.0

** Como eu sempre uso o libvirt em conjunto, não foi testado a compatibilidade só com o Qemu. Veja a documentação das ferramentas para mais detalhes. 

## Criando as imagens

Dentro da máquina com os requisitos, e após configurar as variáveis desejadas, rodar os comandos abaixo para a construção da imagem.

Dentro da pasta do repositório:

```
packer init .
packer build .
```

```
➜  packer-cloud-image git:(main) ✗ packer build . 
qemu.debian: output will be in this color.

==> qemu.debian: Retrieving ISO
==> qemu.debian: Trying http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso
==> qemu.debian: Trying http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso?checksum=sha256%3A45c9feabba213bdc6d72e7469de71ea5aeff73faea6bfb109ab5bad37c3b43bd
    qemu.debian: debian-11.2.0-amd64-netinst.iso 378.00 MiB / 378.00 MiB [===============================================================================] 100.00% 40s
==> qemu.debian: http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-11.2.0-amd64-netinst.iso?checksum=sha256%3A45c9feabba213bdc6d72e7469de71ea5aeff73faea6bfb109ab5bad37c3b43bd => /home/lucas/.cache/packer/b0bda6bf8607e4ebd1f65e31782e6f7ad61b2e36.iso
==> qemu.debian: Starting HTTP server on port 8088
==> qemu.debian: Found port for communicator (SSH, WinRM, etc): 2629.
==> qemu.debian: Looking for available port between 5900 and 6000 on 127.0.0.1
==> qemu.debian: Starting VM, booting from CD-ROM
    qemu.debian: The VM will be run headless, without a GUI. If you want to
    qemu.debian: view the screen of the VM, connect via VNC without a password to
    qemu.debian: vnc://127.0.0.1:5933
==> qemu.debian: Waiting 3s for boot...
==> qemu.debian: Connecting to VM via VNC (127.0.0.1:5933)
==> qemu.debian: Typing the boot command over VNC...
    qemu.debian: Not using a NetBridge -- skipping StepWaitGuestAddress
==> qemu.debian: Using SSH communicator to connect: 127.0.0.1
==> qemu.debian: Waiting for SSH to become available...
```

Você pode acompanhar o processo de instalação via VNC. Uma porta local será alocada para tal e será informada a você, como no exemplo de saída acima. Obs.: Durante a digitação das linhas, percebi que ao se conectar via VNC, a mesma é interrompida, portanto aconselho conectar após tal etapa. 

Se você quiser apenas uma determinada imagem, pode executar com `only`: 
```
packer build --only=qemu.debian .
``` 

Por default, as imagens serão jogadas para a pasta `build`.

## Exemplos com Terraform

Exemplos de como usar estas imagens com Terraform nos diversos provedores podem ser encontrados dentro da pasta `exemplos` deste repositório.

# Contribuindo

Contribuições são bem vindas. Fique a vontade para fazer um fork e posteriormente submeter seu PR para avaliação.
