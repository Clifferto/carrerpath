/*
===============================================================================
 Name        : drvTimer.c
 Author      : Clifferto
 Version     : 1.0
 Copyright   : $(copyright)
 Description : Inicializacion de modulos por default, 
	       estas funciones estan al final de los .c de cada Driver
===============================================================================
*/

///////////////////////////////////////////////////////////////////

/*********************************************************************//**
 * @brief         Get pinsel default config
 * @param[in]     PINSEL_ConfigStruct: Pointer to PINSEL_CFG_Type struct
 *
 * @return        none
 **********************************************************************/
void PINSEL_GetDefaultCfg(PINSEL_CFG_Type *PinCfg)
{
	/*
	 * Defalult:
	 * 			Pin a GPIO.
	 * 			Opendrain off.
	 * 			Pull-up.
	 */
 	PinCfg->Funcnum=PINSEL_FUNC_0;
	PinCfg->OpenDrain=PINSEL_PINMODE_NORMAL;
	PinCfg->Pinmode=PINSEL_PINMODE_PULLUP;

    return;
}

//////////////////////////////////////////////////////////////////////////

/*********************************************************************//**
 * @brief         Get timer default config
 * @param[out]    TIM_ConfigStruct: Pointer to TIM_TIMERCFG_Type struct
 *
 * @return        none
 **********************************************************************/
void TIM_GetDefaultCfg(TIM_TIMERCFG_Type *pCfgTim)
{
	/*
	 * Defaults:
	 * 			Modo timer.
	 * 			Prescaler por valor absoluto.
	 */
	TIM_ConfigStructInit(TIM_TIMER_MODE, pCfgTim);
	pCfgTim->PrescaleOption=TIM_PRESCALE_TICKVAL;

    return;
}

/*********************************************************************//**
 * @brief         Get match default config
 * @param[out]    MATCH_ConfigStruct: Pointer to TIM_MATCHCFG_Type struct
 *
 * @return        none
 **********************************************************************/
void TIM_GetDefaultMatch(TIM_MATCHCFG_Type *pCfgMatch)
{
	/*
	 * Defaults:
	 * 			Sin match externo.
	 * 			Interrupcion en match off.
	 * 			Reset en match on.
	 * 			Stop en match off.
	 */
	pCfgMatch->ExtMatchOutputType=TIM_EXTMATCH_NOTHING;
	pCfgMatch->IntOnMatch=DISABLE;
	pCfgMatch->ResetOnMatch=ENABLE;
	pCfgMatch->StopOnMatch=DISABLE;

    return;
}


