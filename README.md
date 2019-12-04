# Assinatura de PDF's com Certificado Digital PFX

### Verificar se o java está instalado

 `java -version`
 
### Se precisar compilar o Java execute:

```
rm sign.class
make
```

### Assinar um PDF

#### Considerando que o certificado e os pdf's estão no mesmo diretório
#### Desta forma roda em Linux ou Mac Os X

`./sign.sh certificado.pfx SENHA arquivo.pdf arquivo_assinado.pdf`
