import com.lowagie.text.pdf.*;
import com.lowagie.text.*;
import java.security.cert.*;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.io.*;
import java.lang.System;

public class sign {
 
public static void main(String[] args) 
{
  PdfReader reader;
  PdfSignatureAppearance sap;
  PdfStamper stp;
  FileOutputStream fout;
  PrivateKey key;
  Certificate[] chain;
  KeyStore ks;

  try
  {
    ks = KeyStore.getInstance("pkcs12");
    ks.load(new FileInputStream(args[0]), args[1].toCharArray());
  }
  catch(Exception e)
  {
    System.out.print("Error loading certificate store: " + e + "\n");
    return;
  }

  try
  {
    String alias = (String)ks.aliases().nextElement();
    key = (PrivateKey)ks.getKey(alias, args[1].toCharArray());
    chain = ks.getCertificateChain(alias);
  }
  catch(Exception e)
  {
    System.out.print("Problems loading key or chain: " + e + "\n");
    return;
  }

  try
  {
    reader = new PdfReader(args[2]);
    fout = new FileOutputStream(args[3]);
  }
  catch(Exception e)
  {
    System.out.print("Problems initialising PDF reader: " + e + "\n");
    return;
  }

  try
  {
    stp = PdfStamper.createSignature(reader, fout, '\0', new File("/tmp"));
    sap = stp.getSignatureAppearance();
  }
  catch(Exception e)
  {
    System.out.print("Problems creating: " + e + "\n");
    return;
  }

  try
  {
    sap.setCrypto(key, chain, null, PdfSignatureAppearance.WINCER_SIGNED);
  }
  catch(Exception e)
  {
    System.out.print("Problem setting crypto: " + e + "\n");
    return;
  }

  System.out.print("Assinatura concluida.\n");

  try
  {
    stp.close();
  }
  catch(Exception e)
  {
    System.out.print("Problem with closing: " + e + "\n");
  }

}

}
