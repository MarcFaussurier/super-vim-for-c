/* A packrat parser generated by PackCC 1.2.5 */

#ifndef PCC_INCLUDED__PEG_VARLINK_H
#define PCC_INCLUDED__PEG_VARLINK_H

struct parserCtx;

#ifdef __cplusplus
extern "C" {
#endif

typedef struct pvarlink_context_tag pvarlink_context_t;

pvarlink_context_t *pvarlink_create(struct parserCtx *auxil);
int pvarlink_parse(pvarlink_context_t *ctx, int *ret);
void pvarlink_destroy(pvarlink_context_t *ctx);

#ifdef __cplusplus
}
#endif

#endif /* PCC_INCLUDED__PEG_VARLINK_H */
