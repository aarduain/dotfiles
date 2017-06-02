#!/bin/bash
npm run coverage | tail -n6 | mail -s "Coverage Report" alain.arduain@alchemysystems.com,alex.wallace@alchemysystems.com,scott.lin@alchemysystems.com,lance.brieden@alchemysystems.com,shawn.dibble@alchemysystems.com
