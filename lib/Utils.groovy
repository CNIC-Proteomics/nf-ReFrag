//
// This file holds several Groovy functions that could be useful for any Nextflow pipeline
//

import java.io.File
import org.codehaus.groovy.runtime.StackTraceUtils

class Utils {

    //
    // Retrieves the name file without extension
    //
    public static String getBaseName(String filePath) {
        def basename = new File(filePath).getBaseName()
        return basename
    }
    //
    // Get the method name
    //
    static def getCurrentMethodName(){
        def marker = new Throwable()
        return StackTraceUtils.sanitize(marker).stackTrace[1].methodName
    }
    //
    // Print file from the given string
    //
    public static String writeStrIntoFile(content, ifile) {
        // declare variable
        def ofile = ''
        try {
            ofile = new File(ifile)
            ofile.write(content)
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        return ofile
    }
    //
    // Create String in Ini format from report (map of sections: {key,value}
    //
    public static String createIniStr(report) {
        def result = ''
        try {
            report.each { section,params ->
                result += "[${section}]\n"
                params.each { key,val ->
                    result += "${key} = ${val}\n"
                }
                result += "\n"
            }
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        return result
    }
    //
    // Create report (list of maps) from an INI file
    //
    public static Map parseIniFile(ifile) {
        def result = [:]
        try {
            def fileReader = new File(ifile.toString()).text
            def currentSection = null
            fileReader.split("\n").each() { line ->
                line = line.trim()
                line = line.replaceAll(/(#).*/, '')
                if (line.startsWith("[")) {
                    // It's a section header
                    currentSection = line.replaceAll("\\[|\\]", "").trim()
                    result[currentSection] = [:]
                } else if (line && !line.startsWith("#")) {
                    // It's a key-value pair (not empty and not a comment)
                    def keyValue = line.split('=').collect { it.split('/(#)/')[0].trim() }
                    if (currentSection) {
                        // Add the key-value pair to the current section
                        result[currentSection][keyValue[0]] = keyValue[1]
                    }
                }
            }
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        return result
    }
    //
    // Extract the parameter section from a parameter file (INI)
    //
    public static String extractParamSection(ifile, sections) {
        // declare variable
        def params_str = ''
        try {
            // parse Ini file
            def params = parseIniFile(ifile)
            // get parameters from the given sections
            def params_data = [:]
            sections.each { section ->
                if ( params.containsKey(section) ) {
                    params_data[section] = params[section]
                }
                else {
                    throw new Exception("Key '$replace.key' is not in the parameter file.")
                }
            }
            // create str with Ini report
            params_str = createIniStr(params_data)
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        return params_str
    }
    //
    // Update the parameter file (INI) with the provided parameters
    //
    public static String updateParamsFile(ifile, replaces) {
        // declare variable
        def ofile = ''
        def content = ''
        try {
            // read the file contents into a variable
            def f = new File(ifile.toString())
            content = f.text
            // replace attributes by the given ones
            replaces.each { replace ->
                def pattern = ~/${replace.key}\s*=.*/
                content = content.replaceAll(pattern,"${replace.key}=${replace.value}")
            }
            // // define output file
            // def ofilename = "${f.getParent()}${File.separator}updated_${f.name}"
            // // write the output parameter file
            // ofile = new File(ofilename)
            // ofile.write(content)
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        // return ofile
        return content
    }
    //
    // Extract the parameter section from a parameter file (INI)
    //
    public static String mergeIniFiles(ifile1, ifile2) {
        // declare variable
        def params_str = ''
        try {
            // parse Ini files
            def params1 = parseIniFile(ifile1)
            def params2 = parseIniFile(ifile2)
            // add the section/parameters (params2) into fixed parameters (params1)
            def params_data = params1
            params2.each { section, params ->
                // the section from params2 are within params_data
                if ( params_data.containsKey(section) ) {
                    params.each { key,val ->
                        // We add the parameters from params2 into params_data if they do not exist
                        if ( !params_data[section].containsKey(key) ) {
                            params_data[section][key] = val
                        }
                    }
                }
                else { // add the new section from params2 into params_data
                    params_data[section] = params
                }
            }
            // create str with Ini report
            params_str = createIniStr(params_data)
        } catch(Exception ex) {
            println("ERROR: ${new Object(){}.getClass().getEnclosingMethod().getName()}: $ex.")
            System.exit(1)
        }
        return params_str
    }



    // //
    // // Create report (map) with the parameters from the MSFragger file
    // //
    // static def parseMsfFile(fileName) {
    //     // declare variables
    //     def result = [:]
    //     try {
    //         def fileReader = new File(fileName).text
    //         def currentSection = null
    //         fileReader.split("\n").each() { line ->
    //             line = line.trim()
    //             if (line && !line.startsWith("#")) {
    //                 // It's a key-value pair (not empty and not a comment)
    //                 def keyValue = line.split('=').collect { it.split('#')[0].trim() }
    //                 def key = keyValue[0]
    //                 def val = keyValue[1]
    //                 if ( !result.containsKey(key) ) {
    //                     result[key] = val
    //                 }
    //                 else {
    //                     throw new Exception("Key '$key' is duplicated in the parameter file.")
    //                 }
    //             }
    //         }

    //     } catch(Exception ex) {
    //         println("ERROR:${new Object(){}.getClass().getEnclosingMethod().getName()}:$ex")
    //         System.exit(1)
    //     }

    //     return result
    // }

    // //
    // // Update the MSFragger parameter file with the provided parameters
    // //
    // public static Map updateMsfParams(String ifile, replaces) {
    //     // parse the MSF file
    //     def param_data = parseMsfFile(ifile.toString())
    //     // update the given attributes
    //     try {
    //         replaces.each { replace ->
    //             if ( param_data.containsKey(replace.key) ) {
    //                 param_data[replace.key] = replace.value
    //             }
    //             else {
    //                 throw new Exception("Key '$replace.key' is not in the parameter file.")
    //             }
    //         }
    //     } catch(Exception ex) {
    //         println("ERROR:${new Object(){}.getClass().getEnclosingMethod().getName()}:$ex")
    //         System.exit(1)
    //     }
    //     return param_data
    // }
}
