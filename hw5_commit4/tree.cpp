#include<iostream>
#include"tree.h"
using namespace std;
TreeNode::TreeNode(int NodeType)
    :nodeType(NodeType), nodeIndex(0),
    opType(-1), bool_val(false), int_val(-1), str_val(""),
    varName(" "), varType(-1), varFlag(VAR_COMMON)
{
    switch (NodeType)
    {
    case NODE_PROG: 
        break;
    case NODE_STMT:
        break;
    case NODE_OP:
        opType = 0;
        break;
    case NODE_BOOL:
        bool_val = false;
        break;
    case NODE_CONINT: 
        int_val = 0;
        break;
    case NODE_CONCHAR:
        int_val = 0;
        break;
    case NODE_CONSTR:
        str_val = "";
    case NODE_VAR:
        varName = "";
        break;
    case NODE_TYPE:
        varType = 0;
        break;
    default:
        break;
    }
}
void TreeNode::addChild(TreeNode* child)
{
    this->CHILDREN.push_back(child);
    while (!child->SIBLING.empty())
    {
        this->CHILDREN.push_back(child->SIBLING[0]);
        child->SIBLING.erase(begin(child->SIBLING));
    }
}
TreeNode* TreeNode::getChild(int index)
{
    return this->CHILDREN[index];
}
int TreeNode::childNum()
{
    return this->CHILDREN.size();
}
void TreeNode::addSibling(TreeNode *sibling)
{
    this->SIBLING.push_back(sibling);
}
void TreeNode::genNodeId()
{
    nodeIndex = NodeIndex++;
    for (int i = 0; i < this->CHILDREN.size(); i++)
    {
        this->CHILDREN[i]->genNodeId();
    }
}
void TreeNode::printAST()
{
    string NType, value;
    switch (this->nodeType)
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
        case OP_MULTI:
            value = "*\t\t";
            break;
        case OP_DIV:
            value = "/\t\t";
            break;
        case OP_MOD:
            value = "%\t\t";
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
        case OP_NEG:
            value = "NEGATIVE";
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
        case OP_EQ:
            value = "==\t\t";
            break;
        case OP_LT:
            value = "<\t\t";
            break;
        case OP_LE:
            value = "<=\t\t";
            break;
        case OP_BT:
            value = ">\t\t";
            break;
        case OP_BE:
            value = ">=\t\t";
            break;
        case OP_NE:
            value = "!=\t\t";
            break;
        default:
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
    case NODE_CONINT:
        NType = "constint";
        value = to_string(this->int_val) + "\t\t";
        break;
    case NODE_CONCHAR:
        NType = "constchar";
        value = char(this->int_val) + "\t\t";
        break;
    case NODE_CONSTR:
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
    case NODE_ASSIGN:
        NType = "assign\t";
        value = "\t\t";
        break;
    case NODE_FEXPR:
        NType = "FORargs\t";
        value = "\t\t";
        break;
    case NODE_STRDEF:
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