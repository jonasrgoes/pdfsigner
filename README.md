# pdfsigner

### Verificar se o java está instalado

 `java -version`
 
### Se precisar compilar o Java execute:

```
rm sign.class
make
```

### Assinar um PDF

#### Considerando que o certificado e os pdf's estão no mesmo diretório

`./sign.sh certificado.pfx SENHA arquivo.pdf arquivo_assinado.pdf`
