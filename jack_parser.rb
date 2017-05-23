require "babel_bridge"

class JackParser < BabelBridge::Parser
  ignore_whitespace

  #Upper level program structures
  rule :class, :keyword2, :className, :symbol5, :classVarDecPos?, :subroutineDecPos?, :symbol5 
  rule :classVarDecPos, :classVarDec, :classVarDecPosEnd
  rule :classVarDecPosEnd, :classVarDecPos
  rule :classVarDecPosEnd, ''
  rule :subroutineDecPos, :subroutineDec, :subroutineDecPosEnd
  rule :subroutineDecPosEnd, :subroutineDecPos
  rule :subroutineDecPosEnd, ''
  rule :subroutineDec, :keyword5, :keyword13, :subroutineName, :symbol6, :parameterList?, :symbol6, :subroutineBody
  rule :subroutineDec, :keyword5, :type, :subroutineName, :symbol6, :parameterList?, :symbol6, :subroutineBody
  rule :subroutineBody, :symbol5, :varDecPos?, :statements, :symbol5
  rule :varDecPos, :varDec, :vardecPosEnd?
  rule :vardecPosEnd, :varDecPos
  rule :vardecPosEnd, ''

  #Expressions
  rule :statements, :statementPos?
  rule :statementPos, :statement, :statementsEnd
  rule :statementsEnd, :statementPos
  rule :statementsEnd, ''
  rule :statement, :letStatement
  rule :statement, :ifStatement
  rule :statement, :whileStatement
  rule :statement, :doStatement
  rule :statement, :returnStatement
  rule :letStatement, :keyword7, :varName, :symbol4, :expression, :symbol4, :symbol3, :expression, :symbol2
  rule :letStatement, :keyword7, :varName, :symbol3, :expression, :symbol2
  rule :returnStatement, :keyword11, :expression, :symbol2
  rule :returnStatement, :keyword11, :symbol2
  rule :doStatement, :keyword10, :subroutineCall, :symbol2
  rule :whileStatement, :keyword9, :symbol6, :expression, :symbol6, :symbol5, :statements, :symbol5
  rule :ifStatement, :keyword8, :symbol6, :expression, :symbol6, :symbol5, :statements, :symbol5
  rule :ifStatement, :keyword8, :symbol6, :expression, :symbol6, :symbol5, :statements, :symbol5, :keyword8, :symbol5, :statements, :symbol5
  rule :term, :subroutineCall
  rule :subroutineCall, :subroutineName, :symbol6, :expressionList, :symbol6
  rule :subroutineCall, :className, :symbol7, :subroutineName, :symbol6, :expressionList?, :symbol6
  rule :subroutineCall, :varName, :symbol7, :subroutineName, :symbol6, :expressionList?, :symbol6
  rule :expressionList, :expression, :expressionListEnd?
  rule :expressionListEnd, :symbol1, :expression, :expressionListEnd 
  rule :expressionListEnd, '' 
  rule :term, :varName, :symbol4, :expression, :symbol4
  rule :term, :symbol6, :expression, :symbol6
  rule :expression, :term, :expressionEnd
  rule :expressionEnd, :symbol3, :expression
  rule :expressionEnd, ''
  rule :term, :integerConstant
  rule :term, :StringConstant
  rule :term, :keyword8
  rule :term, :varName
  rule :term, :symbol, :term

  #program structure
  rule :classVarDec, :keyword3, :type, :varName, :classVarDecEnd #$
  rule :classVarDecEnd, :symbol1, :varName, :classVarDecEnd 
  rule :classVarDecEnd, :symbol2 
  rule :parameterList, :type, :varName, :symbol1, :parameterList #$
  rule :parameterList, :type, :varName
  rule :varDec, :keyword6, :type, :varName, :varDecEnd #$
  rule :varDecEnd, :symbol1, :varName, :varDecEnd
  rule :varDecEnd, :symbol2 
  rule :type, :keyword4
  rule :type, :className 
  rule :className, :identifier 
  rule :subroutineName, :identifier
  rule :varName, :identifier

  #Lexical elements
  rule :identifier, /[a-zA-Z]+[a-zA-Z0-9_]*/ do#$
    JackParser.node_class(:identifier)
  end
  rule :StringConstant, /"[a-zA-Z0-9_]*"/ #$
  rule :keyword2, /class/ do#divided keywords for error handling  #$
    def evaluate
      JackParser.node_class(:class)
    end
  end
  rule :keyword3, /static|field/ #$
  rule :keyword4, /int|char|boolean/ #$
  rule :keyword5, /constructor|function|method/ #$
  rule :keyword6, /var/ #$
  rule :keyword7, /let/ #$
  rule :keyword8, /if|else/ #$
  rule :keyword9, /while/ #$
  rule :keyword10, /do/ #$
  rule :keyword11, /return/ #$
  rule :keyword12, /true|false|null|this/ #$
  rule :keyword13, /void/
  rule :symbol, /[-~]/ #divided symbols for error handling #$
  rule :symbol1, /,/ #$
  rule :symbol2, /;/ #$
  rule :symbol3, /[-+*\/|&<>=]/ #$
  rule :symbol4, /[\[\]]/ #$
  rule :symbol5, /[{}]/ #$
  rule :symbol6, /[()]/ #$
  rule :symbol7, /./ #$
  rule :integerConstant, /[0-9]+/ #$
end 

files=false
parser = JackParser.new
ARGV.each do |file|
  result = parser.parse(File.read(file)).inspect
  File.open("result.xml", 'w') { |file| file.write(result) }
  files = true
end

if !files 
  BabelBridge::Shell.new(JackParser.new).start
end