package it.gov.mgs.account_service.data.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.Version;
import lombok.Getter;
import lombok.Setter;

import java.time.OffsetDateTime;

/**
 * Base astratta per le entità con campi di auditing e informazioni di versioning/validità temporale.
 * <p>
 * I campi sono popolati dal database (DEFAULT, TRIGGER, system-versioned temporal tables) e quindi
 * marcati {@code insertable = false} e {@code updatable = false} per evitare modifiche lato applicazione.
 * </p>
 */
@Getter
@Setter
@MappedSuperclass
public abstract class AuditedEntity {

    @Column(name = "sys_created_by", nullable = false, length = 128, updatable = false, insertable = false)
    private String sysCreatedBy;

    @Column(name = "sys_created_on", nullable = false, updatable = false, insertable = false)
    private OffsetDateTime sysCreatedOn;

    @Column(name = "sys_updated_by", length = 128, insertable = false, updatable = false)
    private String sysUpdatedBy;

    @Column(name = "sys_updated_on", insertable = false, updatable = false)
    private OffsetDateTime sysUpdatedOn;

    @Version
    @Column(name = "sys_rowversion", insertable = false, updatable = false)
    private byte[] sysRowversion;

    @Column(name = "sys_valid_from", nullable = false, updatable = false, insertable = false)
    private OffsetDateTime sysValidFrom;

    @Column(name = "sys_valid_to", nullable = false, updatable = false, insertable = false)
    private OffsetDateTime sysValidTo;
}
