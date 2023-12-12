<!-- @format -->

# Capitulo 2: Preparando o Sistema Anfitrião

Primeiro precisamos criar uma partição nativa Linux (ext4) com no mínimo 20GB fiz isso usando o gparted.

Criaremos também uma partição de SWAP, de no mínimo 2GB, ela serve como backup para memória RAM armazenar processos menos utilizados.

Uma parte importante do livro [LFS-SYSD-BOOK-12.0-pt_BR.pdf](./LFS-SYSD-BOOK-12.0-pt_BR.pdf) está na página 16 e 17 que diz o seguinte:

```
O LFS consegue usar qualquer sistema de arquivos reconhecido pelo kernel Linux, mas os tipos mais comuns são ext3 e ext4. A escolha do sistema de arquivos certo pode ser complexa; depende das características dos arquivos e do tamanho da partição. Por exemplo:

ext2
é adequado para partições pequenas que são atualizadas com pouca frequência tais como /boot.

ext3
é  uma  atualização  do  ext2  que  inclui  um  diário  para  ajudar  a  recuperar  a  situação  da  partição  no  caso  de desligamento inadequado. É comumente usada como sistema de arquivos de propósito geral.

ext4
é a versão mais recente da família ext de sistemas de arquivos. Ela fornece várias capacidades novas incluindo carimbos de tempo em nano segundos; criação e uso de arquivos muito grandes (até 16 TB); e melhoramentos de velocidade
```

O LFS assume que o sistema de arquivos raiz (/) é do tipo ext4. Para criar um sistema de arquivos ext4 na partição
do LFS, use o seguinte comando:

```bash
mkfs -v -t ext4 /dev/<xxx>
```

Substitua `<xxx>` pelo nome da partição do LFS.

Se você estiver usando uma partição swap existente, [então] não há necessidade de formatá-la. Se uma nova partição
swap foi criada, [então] ela precisará ser inicializada com este comando:

```bash
mkswap /dev/<yyy>
```

Substitua `<yyy>` pelo nome da partição swap.

## VARIAVEL DE AMBIENTE LFS

A variável de ambiente LFS será usada muitas vezes. Você deveria se assegurar de que essa
variável sempre está definida no decorrer do processo de construção do LFS. Ela deveria ser configurada para o
nome do diretório onde você estará construindo seu sistema LFS.

```bash
export LFS=/mnt/lfs
```

Sempre cheque se a variável LFS está bem configurada quando mudar de ambiente, como quando fizer um `su` para root ou outro usuário, ou acessar outro terminal, verifique digitando

```bash
echo $LFS
```

## Montando a nova partição LFS

Crie o ponto de montagem e monte o sistema de arquivos do LFS com estes comandos:

```bash
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
```

Substitua `<xxx>` pelo nome da partição do LFS.
Se estiver usando múltiplas partições para o LFS (por exemplo, uma para / e outra para /home), [então] monte-as
como isto:

```bash
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
mkdir -v $LFS/home
mount -v -t ext4 /dev/<yyy> $LFS/home
```

Substitua `<xxx>` e `<yyy>` pelos nomes apropriados das partições.

Assegure-se de que essa nova partição não esteja montada com permissões que sejam restritivas demais (tais como
as opções nosuid ou nodev). Execute o comando mount sem quaisquer parâmetros para ver quais opções estão
configuradas para a partição do LFS montada. Se nosuid e (ou) nodev estiverem configuradas, [então] a partição
precisa ser remontada.

_OBSERVAÇÃO:_ Toda vez que reiniciar o sistema anfitrião é preciso remontar a partição LFS

Se você estiver usando uma partição swap, [então] assegure-se de que ela está habilitada usando o comando swapon:

```bash
/sbin/swapon -v /dev/<zzz>
```

Substitua `<zzz>`` pelo nome da partição swap.
