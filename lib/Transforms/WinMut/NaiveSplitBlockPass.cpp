#include <llvm/Transforms/WinMut/NaiveSplitBlockPass.h>

#include "llvm/IR/Constants.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"

bool NaiveSplitBlockPass::runOnModule(Module &M) {
  bool ret = false;
  for (auto &f : M) {
    if (!f.isDeclaration()) {
      for (auto &bb : f) {
        auto *curbb = &bb;
        while (curbb->size() > this->maxBBSize) {
          ret = true;
          auto it = curbb->begin();
          for (int i = 0; i < 10; ++i) {
            if (isa<PHINode>(&*it)) {
              --i;
            }
            ++it;
            if (it == curbb->end()) {
              goto end;
            }
          }
          if (it == curbb->end()) {
            goto end;
          }
          curbb = curbb->splitBasicBlock(it, "");
        }
      }
    end:
      continue;
    }
  }
  return ret;
}

// #define maxBBSize_OUTPUT
NaiveSplitBlockPass::NaiveSplitBlockPass() : ModulePass(ID), maxBBSize(15) {
#ifdef maxBBSize_OUTPUT
  errs() << "maxBBSize: set by default: " << this->maxBBSize << "\n";
#endif
}

NaiveSplitBlockPass::NaiveSplitBlockPass(uint32_t maxBBSize) : ModulePass(ID), maxBBSize(maxBBSize) {
#ifdef maxBBSize_OUTPUT
  errs() << "maxBBSize: set by commandLine: " << this->maxBBSize << "\n";
#endif
}

char NaiveSplitBlockPass::ID = 0;
static RegisterPass<NaiveSplitBlockPass> X("WinMut-NaiveSplitBlockPass",
                                           "WinMut - Split large basic blocks");
