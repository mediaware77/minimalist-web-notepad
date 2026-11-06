# Publicacao no qoserver

- URL publica: https://notas.docx.ia.br
- Fork: https://github.com/mediaware77/minimalist-web-notepad
- Origem: https://github.com/pereorga/minimalist-web-notepad
- Deploy pelo Dokploy, projeto `Notas`, servico Compose `notepad`, branch `master`.
- Dockerfile PHP 8.4 + Apache, com rewrite habilitado.
- DNS curinga existente de docx.ia.br na Cloudflare; o router de host exato do
  Dokploy tem precedencia sobre o router curinga do DocX.
- HTTPS usa o certificado curinga da origem ja configurado no Traefik e o
  certificado publico da Cloudflare. Nenhum segredo fica neste repositorio.

## Dados e acesso

As notas ficam no volume Docker `minimalist-web-notepad-notes`, montado em
`/var/lib/notepad`, fora do diretorio publico do Apache. Rebuild e recriacao do
container preservam os dados. Nao remover o volume ao atualizar.

Nao ha login: qualquer pessoa que conheca o link pode ler, alterar e apagar a
nota. A raiz cria um endereco aleatorio de 128 bits. Enderecos personalizados
curtos continuam possiveis, mas sao faceis de adivinhar. Nao guardar senhas.

Abra o mesmo link em outro aparelho para continuar. Nao ha sincronizacao em
tempo real nem resolucao de conflitos: recarregue antes de editar em outro
aparelho; se editar em dois ao mesmo tempo, a ultima gravacao prevalece.
Limite do corpo de cada requisicao: 1 MiB (inclui codificacao do formulario).

O volume persistente nao substitui backup. Backup agendado/externo ainda nao
configurado para este servico.

## Atualizacao

Atualize a branch master e acione Deploy no Dokploy. O painel clona o fork e
compila o Dockerfile pelo compose.yaml. Auto-deploy nao habilitado.

## Reversao

Desative somente este Compose e seu dominio no Dokploy. Preserve o volume de
notas. O router curinga do DocX e os demais servicos nao precisam ser alterados.
