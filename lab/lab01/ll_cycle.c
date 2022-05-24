#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *tortoise = head;
    node *hare = head;
    if (!head) {
	return 0;
    }
    while (hare->next && hare->next->next) {
    	hare = hare->next->next;
	tortoise = tortoise->next;
	if (hare == tortoise) {
	    return 1;
	}
    }
    return 0;
}
