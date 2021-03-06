package cn.edu.sjtu.dcl.mapreduce.creator.impl;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.jar.Attributes;
import java.util.jar.JarEntry;
import java.util.jar.JarInputStream;
import java.util.jar.JarOutputStream;
import java.util.jar.Manifest;

/**
 * Provides utility services for jarring and unjarring files and directories.
 * Note that a given instance of JarHelper is not threadsafe with respect to
 * multiple jar operations.
 * 
 * @author
 */
public class JarHandler
{
	// ========================================================================
	// Constants
	private static final int BUFFER_SIZE = 2156;
	private String MAIN_CLASS;

	// ========================================================================
	// Variables
	private byte[] mBuffer = new byte[BUFFER_SIZE];
	private int mByteCount = 0;
	private boolean mVerbose = false;
	private String mDestJarName = "";

	// ========================================================================
	// Constructor
	/**
	 * Instantiates a new JarHelper.
	 */
	public JarHandler()
	{
	}

	// ========================================================================
	// Public methods
	
	public void setMAIN_CLASS(String mAIN_CLASS)
	{
		MAIN_CLASS = mAIN_CLASS;
	}
	
	/**
	 * Jars a given directory or single file into a JarOutputStream.
	 */
	public void jarDir(File dirOrFile2Jar, File destJar) throws IOException
	{
		
		if(dirOrFile2Jar == null || destJar == null)
			throw new IllegalArgumentException();

		mDestJarName = destJar.getCanonicalPath();
		FileOutputStream fout = new FileOutputStream(destJar);

		JarOutputStream jout;

		if (MAIN_CLASS != null)
		{
			Manifest manifest = new Manifest();
			Attributes attrs = manifest.getMainAttributes();
			attrs.putValue("Manifest-Version", "1.0");
			attrs.putValue("Class-Path", ".");
			attrs.putValue("Main-Class", MAIN_CLASS);
			/**
			 * Manifest-Version: 1.0 Class-Path: . Main-Class: test.JarHelper
			 */
			jout = new JarOutputStream(fout, manifest);
		}
		else
		{
			jout = new JarOutputStream(fout);
		}
		// jout.setLevel(0);
		try
		{
			jarDir(dirOrFile2Jar, jout, null);
		}
		catch (IOException ioe)
		{
			throw ioe;
		}
		finally
		{
			jout.close();
			fout.close();
		}
	}

	/**
	 * Unjars a given jar file into a given directory.
	 */
	public void unjarDir(File jarFile, File destDir) throws IOException
	{
		//BufferedOutputStream dest = null;
		FileInputStream fis = new FileInputStream(jarFile);
		unjar(fis, destDir);
	}

	/**
	 * Given an InputStream on a jar file, unjars the contents into the given
	 * directory.
	 */
	public void unjar(InputStream in, File destDir) throws IOException
	{
		BufferedOutputStream dest = null;
		JarInputStream jis = new JarInputStream(in);
		JarEntry entry;
		while ((entry = jis.getNextJarEntry()) != null)
		{
			if (entry.isDirectory())
			{
				File dir = new File(destDir, entry.getName());
				System.out.println(dir.getCanonicalPath());
				dir.mkdir();
				if (entry.getTime() != -1)
					dir.setLastModified(entry.getTime());
				continue;
			}
			int count;
			byte data[] = new byte[BUFFER_SIZE];
			File destFile = new File(destDir, entry.getName());
			if(!destFile.getParentFile().exists())
				destFile.getParentFile().mkdirs();
			destFile.createNewFile();
			if (mVerbose)
				System.out.println("unjarring " + destFile + " from " + entry.getName());
			FileOutputStream fos = new FileOutputStream(destFile);
			dest = new BufferedOutputStream(fos, BUFFER_SIZE);
			while((count = jis.read(data, 0, BUFFER_SIZE)) != -1)
			{
				dest.write(data, 0, count);
			}
			dest.flush();
			dest.close();
			if (entry.getTime() != -1)
				destFile.setLastModified(entry.getTime());
		}
		jis.close();
	}

	public void setVerbose(boolean b)
	{
		mVerbose = b;
	}

	// ========================================================================
	// Private methods

	private static final char SEP = '/';

	/**
	 * Recursively jars up the given path under the given directory.
	 */
	private void jarDir(File dirOrFile2jar, JarOutputStream jos, String path) throws IOException
	{
		if (mVerbose)
			System.out.println("checking " + dirOrFile2jar);
		if (dirOrFile2jar.isDirectory())
		{
			String[] dirList = dirOrFile2jar.list();
			String subPath = (path == null) ? "" : (path + dirOrFile2jar.getName() + SEP);
			if(path != null)
			{
				JarEntry je = new JarEntry(subPath);
				je.setTime(dirOrFile2jar.lastModified());
				jos.putNextEntry(je);
				jos.flush();
				jos.closeEntry();
			}
			for(int i = 0; i < dirList.length; i++)
			{
				File f = new File(dirOrFile2jar, dirList[i]);
				jarDir(f, jos, subPath);
			}
		}
		else
		{
			if (dirOrFile2jar.getCanonicalPath().equals(mDestJarName))
			{
				if (mVerbose)
					System.out.println("skipping " + dirOrFile2jar.getPath());
				return;
			}

			if (mVerbose)
				System.out.println("adding " + dirOrFile2jar.getPath());
			FileInputStream fis = new FileInputStream(dirOrFile2jar);
			try
			{
				JarEntry entry = new JarEntry(path + dirOrFile2jar.getName());
				entry.setTime(dirOrFile2jar.lastModified());
				jos.putNextEntry(entry);
				while ((mByteCount = fis.read(mBuffer)) != -1)
				{
					jos.write(mBuffer, 0, mByteCount);
					if (mVerbose)
						System.out.println("wrote " + mByteCount + " bytes");
				}
				jos.flush();
				jos.closeEntry();
			}
			catch (IOException ioe)
			{
				throw ioe;
			}
			finally
			{
				fis.close();
			}
		}
	}

	// for debugging
	public static void main(String[] args) throws IOException
	{
//		if (args.length < 2) {
//			System.err
//					.println("Usage: JarHelper jarname.jar directory [MainClass]");
//			return;
//		}
//
//		if (args.length == 3) {
//			MAIN_CLASS = args[2];
//		}

		JarHandler jarHelper = new JarHandler();
		jarHelper.mVerbose = true;
		
//		File test = new File("test");
//		if(!test.exists())
//			test.mkdirs();
//		jarHelper.unjarDir(new File("wc.jar"), test);
		File dirOrFile2Jar = new File("test");
		File destJar = new File("Test.jar");
		jarHelper.setMAIN_CLASS("Test");
		
		jarHelper.jarDir(dirOrFile2Jar, destJar);
	}
}