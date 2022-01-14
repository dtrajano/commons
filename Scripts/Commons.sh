#!/bin/bash

# Calculadores 

function calcularDvCPF() {
	local i soma dv1 dv2 cpfDv1;

	if [ ${#1} -eq 9 ]; then
		for ((i=0; i < ${#1} ; i++)); do 
			soma=$((soma + ${1:$i:1} * (i + 1)));
		done;
		dv1=$(expr $soma % 11);
		[ $dv1 -ge 10 ] && dv1=0;
		cpfDv1=$1$dv1;
		soma=0;
		for ((i=1; i < ${#cpfDv1} ; i++)); do 
			soma=$((soma + ${cpfDv1:$i:1} * i));
		done;
		dv2=$(expr $soma % 11);
		[ $dv2 -ge 10 ] && dv2=0;
		echo "$dv1$dv2";
		return;
	else
		echo "$1 deve ser um CPF de 9 dígitos sem traços e pontos, apenas números.";
		return 1;
	fi;
}

function calcularDvCNPJ() {
  local base soma dv1 cnpjDv1 dv2;

	if [ ${#1} -eq 12 ]; then
		base=9;
		for ((i=${#1} - 1; i >= 0 ; i--)); do 
			soma=$((soma + ${1:i:1} * base));
			base=$((base - 1));
			[ $base -eq 1 ] && base=9;
		done
		dv1=$(expr $soma % 11);
		[ $dv1 -ge 10 ] && dv1=0;
		cnpjDv1=$1$dv1;
		soma=0;
		base=9;
		for ((i=${#cnpjDv1} - 1; i >= 0 ; i--)); do 
			soma=$((soma + ${cnpjDv1:i:1} * base));
			base=$((base - 1));
			[ $base -eq 1 ] && base=9;
		done
		dv2=$(expr $soma % 11);
		[ $dv2 -ge 10 ] && dv2=0;
		# Retorna dv gerado
		echo "$dv1$dv2";
		return;
	else
		echo "$1 deve ser um CNPJ de 12 dígitos sem traços e pontos, apenas números.";
		return 1;
	fi;
}

# Geradores

function gerarCPF() {
  local i cpf;

	if [ ${#1} -eq 9 ]; then
		echo $1$(calcularDvCPF $1);
		return;
	else
		for ((i=0; i<9; i++)); do 
			cpf="$cpf$((RANDOM % 9))"	
		done;
		
        echo $cpf$(calcularDvCPF $cpf);
		return;
	fi
}

function gerarCNPJ() {
  local i cnpj filial;

	if [ ${#1} -eq 12 ]; then
		# Gera o digito do CNPJ informado
		echo $1$(calcularDvCNPJ $1);
		return;
	elif [ ${#1} -le 4 ]; then
		# Cria aleatóriamente a raiz do CNPJ concatena com a filial
		filial=$1;
		while [ ${#filial} -lt 4 ]; do 
			filial="0$filial";
		done;
		for ((i=0; i<8; i++)); do 
			cnpj="$cnpj$((RANDOM % 9))"	
		done;
		echo $cnpj$filial$(calcularDvCNPJ $cnpj$filial);
		return;
	else
		# Cria aleatóriamente todo o conteúdo do CNPJ
		for ((i=0; i<12; i++)); do 
			cnpj="$cnpj$((RANDOM % 9))"
		done;
		echo $cnpj$(calcularDvCNPJ $cnpj);
		return;
	fi
}

# Validadores

function validarCPF() {
	# Se for válido retorna ele mesmo e se não for válido não há retorno.
	# $1 deve ser um CPF de 11 dígitos(com o dígito verificador) sem traços e pontos, apenas números.
	[ "$1" == "$(gerarCPF ${1:0:9})" ] && echo "$1";
}

function validarCNPJ() {
	# Se for válido retorna ele mesmo e se não for válido não há retorno.
	# $1 deve ser um CNPJ de 14 dígitos(com o dígito verificador) sem traços e pontos, apenas números. 
	[ "$1" == "$(gerarCNPJ ${1:0:12})" ] && echo "$1";
}



function validar() {
	# $1 deve ser um documento qualquer sem traços e pontos, apenas números.
	# este algorítimo tenta descobrir o tipo de código
	local tipo;
	tipo="Nenhum";
	[ "$(validarCPF $1)"  == "$1" ] && tipo="CPF";
	[ "$tipo" == "Nenhum" ] && [ "$(validarPIS $1)"  == "$1" ] && tipo="PIS";
	[ "$tipo" == "Nenhum" ] && [ "$(validarCNPJ $1)" == "$1" ] && tipo="CNPJ";
	[ "$tipo" == "Nenhum" ] && [ "$(validarCartaoCredito $1)" == "$1"  ] && tipo="CartaoCredito";
	[ "$tipo" == "Nenhum" ] && [ "$(validarNumCheque $1)" == "$1" ] && tipo="Cheque";
	echo "$tipo";
	return;
}

if [ "$1" ]; then
	case "$1" in
		-h | --help)
			echo "Tente $0 funcao parametro1 parametro2 ... parametroN parametroN+1";
			echo "";
			echo "Funções disponíveis:";
			grep function $0 | cut -d " " -f2 | tr "(){" " ";
			echo "        [ by Gabriel Fernandes gabriel@duel.com.br ]";
      echo "        [      under GPLv2 and no warranties       ]";
		;;
		# $1 deve ser um nome de uma função existente
		*)
			funcao="$1";
			if type $funcao >/dev/null 2>&1 ; then
				shift;
				$funcao "$@"
			else
				echo "$funcao deve ser uma função existente.";
			fi;
		;;
	esac;
fi



case "$1" in
    "") ;;
    gerarCNPJ) "$@";;
    gerarCPF) "$@";;
    *) log_info "Unkown function: $1()";
esac


#EXAMPLES
#export PATH="$PATH:PATHFILE"