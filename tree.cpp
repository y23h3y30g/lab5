#include<iostream>
#include"tree.h"
using namespace std;

TreeNode::TreeNode(int NodeType):nodeType(NodeType),nodeIndex(0),
opType(-1),bool_val(false),int_val(-1),char_val(-1),str_val(""),varName(""),
varType(-1),varFlag(VAR_COMMON){
    switch (NodeType)
    {
    case NODE_BOOL:
        bool_val = false;
        break;
   case NODE_VAR:
        varName = "";
        break;
    case NODE_EXRP:
        break;
    case NODE_TYPE:
        varType = 0;
        break;
    case NODE_STMT:
        break;
    case NODE_PROG:
        break;
    case NODE_OP:
        opType = 0;
        break;
    case NODE_FUNC:
        break;
    case NODE_CINT:
        int_val = 0;
        break;
    case NODE_CCHAR:
        char_val = 0;
        break;
    case NODE_CSTR:
        str_val = "";
    default:
        break;
    }
}

void TreeNode::addChild(TreeNode* Child){
    this->CHILDREN.push_back(Child);
    while(!Child->SIBLING.empty()){
        this->CHILDREN.push_back(Child->SIBLING[0]);
        Child->SIBLING.erase(begin(Child->SIBLING));
    }
}

TreeNode* TreeNode::getChild(int index){
    return this->CHILDREN[index];
}

void TreeNode::addSibling(TreeNode* Sibling){
    this->SIBLING.push_back(Sibling);
}

void TreeNode::genNodeId(){
    nodeIndex = NodeIndex++;
    for(int i = 0; i < this->CHILDREN.size(); i++)
    {
        this->CHILDREN[i]->genNodeId();
    }
}

void TreeNode::printAST(){
    string NType, value;
    switch(this->nodeType)
    {
    case NODE_PROG:
        NType = "program\t";
        value = "\t\t";
        break;
    case NODE_STMT:
    NType = "statement";
    switch (this->stmtType)
        {
        case STMT_IF:
            value = "IF\t\t";
            break;
        case STMT_WHILE:
            value = "WHILE\t";
            break;
        case STMT_FOR:
            value = "FOR\t\t";
            break;
        case STMT_DECL:
            value = "DECL\t";
            break;
        case STMT_ASSIGN:
            value = "ASSIGN\t";
            break;
        case STMT_PRINTF:
            value = "PRINTF\t";
            break;
        case STMT_SCANF:
            value = "SCANF\t";
            break;
        default:
            break;
        }
        break;
    case NODE_OP:
        NType = "op\t\t";
        switch (this->opType)
        {
        case OP_ADD:
            value = "+\t\t";
            break;
        case OP_MINUS:
            value = "-\t\t";
            break;
        case OP_MUL:
            value = "*\t\t";
            break;
        case OP_DIV:
            value = "/\t\t";
            break;
        case OP_MOD:
            value = "%\t\t";
            break;
        case OP_NOT:
            value = "!\t\t";
            break;
        case OP_AND:
            value = "&&\t\t";
            break;
        case OP_OR:
            value = "||\t\t";
            break;
        case OP_AS:
            value = "=\t\t";
            break;    
        case OP_LS:
            value = "<\t\t";
            break;
        case OP_GT:
            value = ">\t\t";
            break;
        case OP_EQ:
            value = "==\t\t";
            break;
        case OP_LE:
            value = "<=\t\t";
            break;
        case OP_GE:
            value = ">=\t\t";
            break;
        case OP_NE:
            value = "!=\t\t";
            break;
        case OP_ADDTO:
            value = "+=\t\t";
            break;
        case OP_MINTO:
            value = "-=\t\t";
            break;
        case OP_MULTO:
            value = "*=\t\t";
            break;
        case OP_DIVTO:
            value = "/=\t\t";
            break;
        case OP_DADD:
            value = "++\t\t";
            break;
        case OP_DMIN:
            value = "--\t\t";
            break;
        }
        break;
    case NODE_TYPE:
        NType = "type\t";
        switch (this->varType)
        {
        case VAR_VOID:
            value = "VOID\t";
            break;
        case VAR_INTEGER:
            value = "INTEGER\t";
            break;
        case VAR_CHAR:
            value = "CHARACTER";
            break;
        case VAR_STRING:
            value = "STRING\t";
            break;
        default:
            break;
        }
        break;
    case NODE_BOOL:
        NType = "bool\t";
        value = this->bool_val ? "true\t" : "false\t";
        break;
    case NODE_CINT:
        NType = "constint";
        value = to_string(this->int_val) + "\t\t";
        break;
    case NODE_CCHAR:
        NType = "constchar";
        value = char(this->char_val) + "\t\t";
        break;
    case NODE_CSTR:
        NType = "conststr";
        value = this->str_val + "\t\t";
        break;
    case NODE_VAR:
        NType = "variable";
        value = this->varName + "\t\t";
        break;
    case NODE_FUNC:
        NType = "function";
        value = "\t\t";
        break;
    case NODE_EXRP:
        NType = "FORargs\t";
        value = "\t\t";
        break;
    case NODE_STRUCT:
        NType = "struct\t";
        value = "\t\t";
    default:
        break;
    }
    printf("%d\t%s\t%s\tchild:", this->nodeIndex, NType.c_str(), value.c_str());
    for (int i = 0; i < this->CHILDREN.size(); i++)
    {
        printf(" %d", this->CHILDREN[i]->nodeIndex);
    }
    printf("\n");
    for (int i = 0; i < this->CHILDREN.size(); i++)
    {
        this->CHILDREN[i]->printAST();
    }
}