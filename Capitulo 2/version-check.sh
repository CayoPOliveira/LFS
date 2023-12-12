#!/bin/bash
# Um script para listar os números de versão de ferramentas críticas de desenvolvimento
# Se você tiver ferramentas instaladas em outros diretórios, ajuste PATH
# aqui E em ~lfs/.bashrc (seção 4.4) também.
LC_ALL=C
PATH=/usr/bin:/bin
bail() { echo "FATAL: $1"; exit 1; }
grep --version > /dev/null 2> /dev/null || bail "grep não funciona"
sed '' /dev/null || bail "sed não funciona"
sort /dev/null || bail "sort não funciona"
ver_check()
{
	if ! type -p $2 &>/dev/null
	then
		echo "ERRO: Não consigo encontrar $2 ($1)"; return 1;
	fi
 	v=$($2 --version 2>&1 | grep -E -o '[0-9]+\.[0-9\.]+[a-z]*' | head -n1)
 	if printf '%s\n' $3 $v | sort --version-sort --check &>/dev/null
 	then
 		printf "OK: %-9s %-6s >= $3\n" "$1" "$v"; return 0;
 	else
 		printf "ERRO: %-9s é MUITO ANTIGO ($3 ou mais recente exigido)\n" "$1";
 		return 1;
 	fi
}

ver_kernel()
{
 	kver=$(uname -r | grep -E -o '^[0-9\.]+')
 	if printf '%s\n' $1 $kver | sort --version-sort --check &>/dev/null
 	then 
		printf "OK: Núcleo Linux $kver >= $1\n"; return 0;
 	else
 		printf "ERRO: Núcleo Linux ($kver) é MUITO ANTIGO ($1 ou mais recente exigido)\n" "$kver";
 		return 1;
 	fi
}

# Coreutils primeiro, pois o sort precisa do Coreutils >= 7.0
ver_check Coreutils sort 7.0 || bail "--version-sort não suportada"
ver_check Bash bash 3.2
ver_check Binutils ld 2.13.1
ver_check Bison bison 2.7
ver_check Diffutils diff 2.8.1
ver_check Findutils find 4.2.31
ver_check Gawk gawk 4.0.1
ver_check GCC gcc 5.1
ver_check "GCC (C++)" g++ 5.1
ver_check Grep grep 2.5.1a
ver_check Gzip gzip 1.3.12
ver_check M4 m4 1.4.10
ver_check Make make 4.0
ver_check Patch patch 2.5.4
ver_check Perl perl 5.8.8
ver_check Python python3 3.4
ver_check Sed sed 4.1.5
ver_check Tar tar 1.22
ver_check Texinfo texi2any 5.0
ver_check Xz xz 5.0.0
ver_kernel 4.14

if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]
then echo "OK: Núcleo Linux suporta UNIX 98 PTY";
else echo "ERRO: Núcleo Linux NÃO suporta UNIX 98 PTY"; fi

alias_check() {
	if $1 --version 2>&1 | grep -qi $2
	then printf "OK: %-4s is $2\n" "$1";
 	else printf "ERRO: %-4s NÃO é $2\n" "$1"; fi
}
echo "Aliases:"
alias_check awk GNU
alias_check yacc Bison
alias_check sh Bash

echo "Compiler check:"
if printf "int main(){}" | g++ -x c++ -
then echo "OK: g++ funciona";
else echo "ERRO: g++ NÃO funciona"; fi
rm -f a.out
