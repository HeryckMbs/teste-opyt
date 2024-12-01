export function formatarDataParaBanco(dataString: string) {
  const partes = dataString.split('/');

  if (partes.length !== 3) {
    throw new Error('Formato de data inválido. Use o formato dd/MM/yyyy.');
  }

  const dia = partes[0].padStart(2, '0');
  const mes = partes[1].padStart(2, '0');
  const ano = partes[2];

  return `${ano}-${mes}-${dia}`;
}
