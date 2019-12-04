# Assinatura de PDF's com Certificado Digital PFX

### Verificar se o java está instalado

 `java -version`
 
### Faça o download dos arquivos

`git clone https://github.com/jonasrgoes/pdfsigner.git`
 
### Se precisar compilar o script em Java execute:

```
rm sign.class
make
```

### Assinar um PDF

#### Considerando que o certificado e os pdf's estão no mesmo diretório
##### Desta forma roda em `Linux` ou `Mac Os X`

`./sign.sh certificado.pfx SENHA arquivo.pdf arquivo_assinado.pdf`

##### Após executar o comando acima verifique se foi criado o `arquivo_assinado.pdf` no diretório.
